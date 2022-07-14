//
//  DesertModels.swift
//  FetchDesertReward
//
//  Created by Bill Calkins on 6/17/22.
//

import Foundation


// MARK: - Deserts
struct Recipes: Decodable, Equatable, Hashable {
    let meals: [Meal]
    
    //Only for use in prototypeing and SwiftUI Previews
#if DEBUG
    static let recipesPlaceholder = Self(meals: [Meal.mealPlaceholder1,
                                                Meal.mealPlaceholder2,
                                                Meal.mealPlaceholder3,
                                                Meal.mealPlaceholder4])
#endif
}

// MARK: - Meal
struct Meal: Decodable, Hashable, Equatable, Identifiable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
    
    
    var id: String {
        self.idMeal
    }
    
    var thumbNailURL: URL? {
        URL(string: self.strMealThumb)
    }
    
    //Only for use in prototyping and SwiftUI Previews
#if DEBUG
    static let mealPlaceholder1 = Self(strMeal: "Apam balid",
                                       strMealThumb: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
                                       idMeal: "53049")
    static let mealPlaceholder2 = Self(strMeal: "Apple & Blackberry Crumble",
                                       strMealThumb: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg",
                                       idMeal: "52893")
    static let mealPlaceholder3 = Self(strMeal: "Apple Frangipan Tart",
                                       strMealThumb: "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg",
                                       idMeal: "52768")
    static let mealPlaceholder4 = Self(strMeal: "Bakewell tart",
                                       strMealThumb: "https://www.themealdb.com/images/media/meals/wyrqqq1468233628.jpg",
                                       idMeal: "52767")
#endif
}


// MARK: - MealDetail
struct MealDetail: Decodable {
    
    let meals: [[String: String?]]
    
    // MARK: Name
    var mealName: String? {
        
        guard let givenMeal = self.meals.first, let mealName = givenMeal["strMeal"] else {
            Log.modelLogger.debug("Unable to unwrap meal details or get meal name.")
            return nil
        }
        
        return mealName ?? nil
    }
    
    // MARK: Instructions
    var mealInstruction: String? {
        
        guard let givenMeal = self.meals.first,
              let mealInstruction = givenMeal["strInstructions"] else {
            Log.modelLogger.debug("Unable to unwrap meal or get meal instructions")
            return nil
        }
        
        return mealInstruction ?? nil
    }
    
    var mealInstructionsList: [String]? {
        
        guard let givenMealInstructions = self.mealInstruction else {
            Log.modelLogger.debug("Unable to unwrap meal instructions")
            return nil
        }
        
        // Need to convert subSequence array to an array of strings for return
        return givenMealInstructions.split(whereSeparator: \.isNewline).map({String($0)})
        
    }
    
    // MARK: Ingredients
    var mealIngredients: [MealIngredients]? {
        
        guard let givenMeal = self.meals.first else {
            Log.viewModelLogger.info("Unable to unwrap meal details.")
            return nil
        }
        
        //filter the ingredients list
        let filteredIngredients = givenMeal.filter({$0.key.contains("strIngredient")})
            .sorted(by: {$0.key < $1.key})
            .compactMap({$0.value}) //remove nil values
            .filter({$0 != ""}) // remove empty strings
        //filter the quantity list
        let filteredMesurements = givenMeal.filter({$0.key.contains("strMeasure")})
            .sorted(by: {$0.key < $1.key})
            .compactMap({$0.value})
            .filter({$0 != ""})
            .filter({$0 != " "})
        
        //ingredients are keys, they need to be unique
        //create a set from the array will drop dups
        let uniqueIngredients = Set(filteredIngredients)
        
        //make sure the ingredients and measures are the same count
        if filteredIngredients.count == uniqueIngredients.count && uniqueIngredients.count == filteredMesurements.count {
            
            //zip both arrays into a dictionary
            let completeInstructions = Dictionary(uniqueKeysWithValues: zip(filteredIngredients, filteredMesurements))
            
            //map dictionary into structured model objects
            return completeInstructions.map({MealIngredients(name: $0.key, quantity: $0.value)}).sorted(by: {$0.name < $1.name})
            
        } else if filteredIngredients.count == filteredMesurements.count {
            // keys are not unique. they cannot be zipped. build manually
            
            var returnedIngredients: [MealIngredients] = []
            let namedIngredients = filteredIngredients.map({MealIngredients(name: $0, quantity: "")})
            
            for (index, ingredient) in namedIngredients.enumerated() {
                returnedIngredients.append(MealIngredients(name: ingredient.name, quantity: filteredMesurements[index]))
            }
            
            return returnedIngredients
            
        } else {
            return nil
        }
        
    }
    
    var mealIngrients: String? {
        
        guard let givenIngredients = self.mealIngredients else {
            Log.viewModelLogger.info("Unable to unwrap meal details.")
            return nil
        }
        
        return givenIngredients.map({$0.description}).joined(separator: "\n")
    }
}

// MARK: Ingredient Struct
struct MealIngredients: CustomStringConvertible, Hashable, Equatable, Identifiable {
    let name: String
    var quantity: String
    
    var id: String { UUID().uuidString }
    
    var description: String {
        "\(name) : \(quantity)"
    }
}

