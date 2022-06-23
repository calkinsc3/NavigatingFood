//
//  DessertDetailView.swift
//  FetchDesertReward
//
//  Created by Bill Calkins on 6/21/22.
//

import SwiftUI

enum CurrentSheetShowing {
    case instructions, ingredients
    
    init() {
        self = .instructions
    }
}

// MARK: - DessertDetailView
struct DessertDetailView: View {
    
    let dessert: Meal
    
    @StateObject var dessertDetailViewModel = DessertDetailsViewModel()
    
    @State private var showingDetailsSheet = false
    @State private var currentSheet = CurrentSheetShowing()
    @State private var dessertDetails: MealDetail?
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            AsyncImage(url: self.dessert.thumbNailURL) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300, alignment: .center)
            } placeholder: {
                ProgressView()
            }
            
            // MARK: Instrucitons
            Button {
                self.showingDetailsSheet = true
                self.currentSheet = .instructions
            } label: {
                Label("Baking Instructions", systemImage: "list.bullet")
            }
            
            // MARK: Ingredients
            Button {
                self.showingDetailsSheet = true
                self.currentSheet = .ingredients
            } label: {
                Label("Baking Ingredients", systemImage: "list.dash.header.rectangle")
            }
            
            Spacer()
        }
        .sheet(isPresented: $showingDetailsSheet) {
            self.showingDetailsSheet = false
        } content: {
            if self.currentSheet == .instructions {
                InstructionsList(instructions: self.dessertDetailViewModel.desertDetail?.mealInstructionsList ?? [], showSheet: $showingDetailsSheet)
            }
            if self.currentSheet == .ingredients {
                IngredientListView(ingredients: self.dessertDetailViewModel.desertDetail?.mealIngredients ?? [], showSheet: $showingDetailsSheet)
            }
        }
        .task {
            await self.dessertDetailViewModel.getDesertDetails(withMealId: self.dessert.idMeal)
            
        }
    }
}

// MARK: - InstructionsList
struct InstructionsList: View {
    
    let instructions: [String]
    @Binding var showSheet: Bool
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                Button {
                    self.showSheet = false
                } label: {
                    Image(systemName: "xmark")
                }
            }
            .padding()
            
            List(self.instructions, id: \.self) { instruction in
                Text(instruction)
                    .font(.body)
                    .padding()
            }
        }
    }
}

// MARK: - IngredientListView
struct IngredientListView: View {
    
    let ingredients: [MealIngredients]
    @Binding var showSheet: Bool
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                Button {
                    self.showSheet = false
                } label: {
                    Image(systemName: "xmark")
                }
            }
            .padding()
            
            List(self.ingredients) { ingredient in
                IngredientView(ingredient: ingredient)
                    .padding()
            }
        }
    }
}

// MARK: - IngredientView
struct IngredientView: View {
    
    let ingredient: MealIngredients
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            Text(ingredient.name)
                .font(.body).bold()
            Spacer()
            Text(ingredient.quantity)
                .font(.body)
        }
    }
}


// MARK: - Previews
struct InstructionsListPreview: View {
    var body: some View {
        InstructionsList(instructions: ["Instruction1", "Instruction2", "Instruction3", "Instruction4", "Instruction5"], showSheet: .constant(true))
    }
}

struct IngredientsListPreview: View {
    var body: some View {
        IngredientListView(ingredients: [MealIngredients(name: "Sugar", quantity: "10 cups"), MealIngredients(name: "Flour", quantity: "5 cups"), MealIngredients(name: "Oil", quantity: "1 cup")], showSheet: .constant(true))
    }
}

struct DessertDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DessertDetailView(dessert: Meal.mealPlaceholder1)
            InstructionsListPreview()
            IngredientsListPreview()
        }
    }
}
