//
//  DesertFetcher.swift
//  FetchDesertReward
//
//  Created by Bill Calkins on 6/17/22.
//

import Foundation
import UIKit


final class DessertFetcher {
    
    private var session: URLSession
    
    init() {
        
        self.session = URLSession(configuration: .default)
        
    }
    
    // MARK: - Get Deserts from API
    func fetchDeserts() async throws -> Recipes {
        
        //assemble URL
        guard let url = self.makeComponentsForDesert().url else {
            throw FoodErrors.urlError(description: "Could not assemble URL for Deserts")
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
    func fetchDesertDetails(withMealId mealId: String) async throws -> MealDetail {
        
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
    
    // MARK: Gather Desert Image
    func getDesertImage(imageURL url: URL) async throws -> UIImage {
        
        let (data, response) = try await self.session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw FoodErrors.apiError(description: "Dessert Image URL retured a non-200 value")
        }
        
        guard let givenImage = UIImage(data: data) else {
            throw FoodErrors.apiError(description: "Data from Dessert Image could not be converted to UIImage")
        }
        
        return givenImage
        
    }
    
}



// MARK: - Endpoint Builder
private extension DessertFetcher {
    
    func makeComponentsForDesert() -> URLComponents {
        
        var components = URLComponents()
        
        components.scheme = MEAL_API.schema
        components.host = MEAL_API.host
        components.path = MEAL_API.desertPath
        components.queryItems = [URLQueryItem(name: "c", value: "Dessert")] //?c=Dessert
        
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

// MARK: - Endpoint Comps
struct MEAL_API {
    static let schema = "https"
    static let host = "www.themealdb.com"
    #if DEBUG
    static let version = "v1/1"
    #else
    static let version = "v2/9973533"
    #endif
    static let basepath = "api/json/\(version)"
    
    static let desertPath = "/\(basepath)/filter.php"
    static let desertDetailPath = "/\(basepath)/lookup.php"
    static let foodCategoriesPath = "/\(basepath)/categories.php"
    
}

