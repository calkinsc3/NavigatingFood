//
//  FoodCategoryViewModel.swift
//  NavigatingFood
//
//  Created by Bill Calkins on 6/24/22.
//

import Foundation


final class FoodCategoryViewModel: ObservableObject {
    
    @Published var foodCategories: FoodCategoryModel = FoodCategoryModel.placeHolder
    @Published var foodRecipes: Recipes = Recipes.recipesPlaceholder
    
    @MainActor
    func getFoodCategories() async {
        let foodFetcher = FoodFetcher()
        do {
            self.foodCategories = try await foodFetcher.fetchCategory()
            if let firstCategory = self.foodCategories.categories.first {
                await self.getFoodRecipes(forCategory: firstCategory.strCategory)
            }
        } catch {
            Log.networkLogger.error("Unable to retrieve categories from API")
        }
    }
    
    @MainActor
    func getFoodRecipes(forCategory categoryID: String) async {
        let foodFetcher = FoodFetcher()
        do {
            self.foodRecipes = try await foodFetcher.fetchRecipes(forGivenCategory: categoryID)
        } catch {
            Log.networkLogger.error("Unable to retrieve recipes from API")
        }
    }
    
    
}
