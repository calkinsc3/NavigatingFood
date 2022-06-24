//
//  FoodFetcher.swift
//  NavigatingFood
//
//  Created by Bill Calkins on 6/24/22.
//

import Foundation

final class FoodFetcher {
    
    private var session: URLSession
    
    init() {
        self.session = URLSession(configuration: .default)
    }
    
    // MARK: - Get Deserts from API
    func fetchCategory() async throws -> FoodCategoryModel {
        
        //assemble URL
        guard let url = self.makeComponentsForCategories().url else {
            throw FoodErrors.urlError(description: "Could not assemble URL for Categories")
        }
        
        let (data, response) = try await self.session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw FoodErrors.apiError(description: "Desert returned a non-200")
        }
        
        do {
            return try JSONDecoder().decode(FoodCategoryModel.self, from: data)
        } catch let error {
            throw FoodErrors.decoding(description: "Error decoding dessert return: \(error)")
        }
    }
    
    // MARK: - Get Deserts from API
    func fetchRecipes(forGivenCategory categoryID: String) async throws -> Recipes {
        
        //assemble URL
        guard let url = self.makeComponentsForRecipe(categoryID: categoryID).url else {
            throw FoodErrors.urlError(description: "Could not assemble URL for Categories")
        }
        
        let (data, response) = try await self.session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw FoodErrors.apiError(description: "Desert returned a non-200")
        }
        
        do {
            return try JSONDecoder().decode(Recipes.self, from: data)
            
        } catch let error {
            throw FoodErrors.decoding(description: "Error decoding dessert return: \(error)")
        }
    }
    

    // MARK: - Get Desert Details from API
    func fetchFoodDetails(withMealId mealId: String) async throws -> MealDetail {
        
        //assemble URL
        guard let url = self.makeComponentsForDesertDetail(mealID: mealId).url else {
            throw FoodErrors.urlError(description: "Could not assemble URL for Desert Details")
        }
        
        let (data, response) = try await self.session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw FoodErrors.apiError(description: "Meal details returned a non-200")
        }
        
        do {
            return try JSONDecoder().decode(MealDetail.self, from: data)
        } catch let error {
            throw FoodErrors.decoding(description: "Error decoding meal details data: \(error)")
        }
        
    }
    
}

// MARK: - Endpoint Builder
private extension FoodFetcher {
    
    func makeComponentsForCategories() -> URLComponents {
        
        var components = URLComponents()
        
        components.scheme = MEAL_API.schema
        components.host = MEAL_API.host
        components.path = MEAL_API.foodCategoriesPath
        
        return components
        
        
    }
    
    func makeComponentsForRecipe(categoryID id: String) -> URLComponents {
        
        var components = URLComponents()
        
        components.scheme = MEAL_API.schema
        components.host = MEAL_API.host
        components.path = MEAL_API.desertPath
        components.queryItems = [URLQueryItem(name: "c", value: id)] //?c=Dessert
        
        return components
    
    }
    
    func makeComponentsForDesertDetail(mealID id: String) -> URLComponents {
        
        var components = URLComponents()
        
        components.scheme = MEAL_API.schema
        components.host = MEAL_API.host
        components.path = MEAL_API.desertDetailPath
        components.queryItems = [URLQueryItem(name: "i", value: id)]
        
        return components
        
    }
}
