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
    @State private var selectedReceipe: Meal?
    
    var body: some View {
        NavigationSplitView {
            List(self.foodCategoryViewModel.foodCategories.sortedCategories, selection: $selectedCategory) {category in
                NavigationLink(value: category) {
                    FoodCategoryCellView(givenCategory: category)
                }
            }
            .navigationTitle("Categories")
        } detail: {
            ZStack { //Fixes Beta Bug
                if let givenSelectedCategory = self.selectedCategory {
                    FoodCategoryDetailView(givenCategory: givenSelectedCategory)
                } else {
                    Text("Select a Category")
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
        VStack (spacing: 20) {
            AsyncImage(url: givenCategory.thumbnailURL) { image in
                image
                    .resizable()
                    .frame(width: 200, height: 200)
            } placeholder: {
                ProgressView()
            }
            Text(givenCategory.strCategory)
                .font(.title)
            Text(givenCategory.strCategoryDescription)
        }
        .padding()
    }
}

// MARK: - Recipes




// MARK: - Previews
struct FoodCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        FoodCategoriesView()
    }
}
