//
//  FoodCategoryView.swift
//  NavigatingFood
//
//  Created by Bill Calkins on 6/24/22.
//

import SwiftUI

struct FoodCategoriesView: View {
    @ObservedObject var foodCategoryViewModel = FoodCategoryViewModel()
    
    @State private var selectedCategory: Category?
    @State private var selectedRecipe: Meal?
    
    var body: some View {
        NavigationSplitView {
            List(self.foodCategoryViewModel.foodCategories.sortedCategories, selection: $selectedCategory) {category in
                NavigationLink(value: category) {
                    FoodCategoryCellView(givenCategory: category)
                }
            }
            .navigationTitle("Categories")
            .task {
                if let givenCategory = self.selectedCategory {
                    await foodCategoryViewModel.getFoodRecipes(forCategory: givenCategory.id)
                }
            }
        } content: {
            List(self.foodCategoryViewModel.foodRecipes.meals, selection: $selectedRecipe) { meal in
                NavigationLink(value: meal) {
                    FoodRecipeCellView(recipe: meal)
                }
            }
        } detail: {
            if let givenMeal = self.selectedRecipe {
                ZStack {
                    DessertDetailView(dessert: givenMeal)
                }
            }
        }
        .task {
            await self.foodCategoryViewModel.getFoodCategories()
        }
    }
}

// MARK: - FoodCategoryCellView
struct FoodCategoryCellView: View {
    
    let givenCategory: Category
    
    var body: some View {
        Text(givenCategory.strCategory)
            .font(.body)
    }
}

// MARK: - FoodCategoryDetailView
struct FoodCategoryDetailView: View {
    
    let givenCategory: Category
    
    var body: some View {
        HStack (spacing: 20) {
            AsyncImage(url: givenCategory.thumbnailURL) { image in
                image
                    .resizable()
                    .frame(width: 50.0, height: 50.0)
            } placeholder: {
                ProgressView()
            }
            Text(givenCategory.strCategory)
                .font(.body)
            Text(givenCategory.strCategoryDescription)
        }
        .padding()
    }
}

// MARK: - Recipes
struct FoodRecipeCellView: View {
    
    let recipe: Meal
    
    var body: some View {
        HStack(alignment: .center) {
            AsyncImage(url: recipe.thumbNailURL) { image in
                image
                    .resizable()
                    .frame(width: 50.0, height: 50.0)
            } placeholder: {
                ProgressView()
            }
            Text(recipe.strMeal)
                .font(.body)
            
        }
    }
}




// MARK: - Previews
struct FoodCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        FoodCategoriesView()
    }
}
