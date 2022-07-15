//
//  NavigatingFoodTests.swift
//  NavigatingFoodTests
//
//  Created by Bill Calkins on 6/23/22.
//

import XCTest
@testable import NavigatingFood

final class NavigatingFoodTests: XCTestCase {
    
    let jsonDecoder = JSONDecoder()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDesertModel() throws {
        
        // Test the desert model
        guard let desertModelData = getMockData(forResource: "Desserts") else {
            XCTFail("Count not find Deserts.json in the file bundle")
            return
        }
        //attempt to decode the data buffer into structured data
        do {
            let desertModel = try jsonDecoder.decode(Recipes.self, from: desertModelData)
            XCTAssertTrue(desertModel.meals.count == 64, "DesertModel meals count should be 64")
            
        } catch {
            XCTFail("Failed to decode Desert data: \(error)")
        }
        
    }
    
    func testMealDetailModel() throws {
        
        // Test the meal detail data structure
        guard let mealDetails = getMockData(forResource: "Meals") else {
            XCTFail("Cannot find Meals.json in the file bundle.")
            return
        }
        
        do {
            let mealModel = try jsonDecoder.decode(MealDetail.self, from: mealDetails)
            if let ingredientsCount = mealModel.meals.first?.count {
                XCTAssertTrue(ingredientsCount == 53, "The ingredients count should be 53")
            }
        } catch {
            XCTFail("Failed to decode Meal Detail data: \(error)")
        }
        
    }
    
    func testMealViewModelMapping() {
        
        // Test the meal detail data structure
        guard let mealDetails = getMockData(forResource: "Meals") else {
            XCTFail("Cannot find Meals.json in the file bundle.")
            return
        }
        
        do {
            let mealModel = try jsonDecoder.decode(MealDetail.self, from: mealDetails)
            XCTAssertTrue(mealModel.meals.count == 1, "The ingredients count should be 1")
            
            // MARK: Test meal name
            if let mealName = mealModel.mealName {
                XCTAssertTrue(mealName == "Apam balik", "Meal name comp prop should be Apam balik")
            } else {
                XCTFail("Could not unwrap mealName")
            }
            
            // MARK: Test meal instructions
            if let mealInstructions = mealModel.mealInstruction {
                XCTAssertTrue(!mealInstructions.isEmpty, "Meal instructions comp prop should not be empty")
            } else {
                XCTFail("Could not unwrap mealInstructions")
            }
            
            // MARK: Test Ingredients
            if let givenMeal = mealModel.meals.first {
                let filteredIngredients = givenMeal.filter({$0.key.contains("strIngredient")})
                    .sorted(by: {$0.key < $1.key})
                    .compactMap({$0.value}) //remove nil values
                    .filter({$0 != ""}) // remove empty strings
                let filteredMesurements = givenMeal.filter({$0.key.contains("strMeasure")})
                    .sorted(by: {$0.key < $1.key})
                    .compactMap({$0.value})
                    .filter({$0 != ""})
                    .filter({$0 != " "})
                
                XCTAssertTrue(filteredIngredients.count == 9, "There should be 9 ingredients after filtering garbage.")
                XCTAssertTrue(filteredMesurements.count == 9, "There should be 9 measurements after filtering garbage")
                
                //zip arrays into a dictionary
                let ingredientDict = Dictionary(uniqueKeysWithValues: zip(filteredIngredients, filteredMesurements))
                
                //move dict into data structure
                let completeInstructions = ingredientDict.map({MealIngredients(name: $0.key, quantity: $0.value)})
                
                XCTAssertTrue(completeInstructions.count == 9, "The complete instructions should be 9")
                
                //This passes inconsistently because arrays are not ordered
                if let sugarIngredient = completeInstructions.first(where: {$0.name == "Sugar"}) {
                    XCTAssertTrue(sugarIngredient.quantity == "45g", "The Surgar associated instruction quantity should be 45g")
                }
                
                // MARK: Test Meal Ingredients
                if let givenIngredients = mealModel.mealIngredients {
                    XCTAssertTrue(givenIngredients.count == 9, "There should be 9 ingredients in the mealIngredients prop")
                }
            }
            
            
        } catch {
            XCTFail("Failed to decode Meal Detail data: \(error)")
        }
    }
    
    func testFoodCatModel() {
        
        // Test the meal detail data structure
        guard let foodCatsData = getMockData(forResource: "FoodCats") else {
            XCTFail("Cannot find Meals.json in the file bundle.")
            return
        }
        
        do {
            let foodCats = try jsonDecoder.decode(FoodCategoryModel.self, from: foodCatsData)
            
            XCTAssertTrue(foodCats.categories.count == 14, "The ingredients count should be 53")
            
        } catch {
            XCTFail("Failed to decode Food Cats data: \(error)")
        }
        
    }
    
    
    
    // MARK: - Helper Functions
    private func getMockData(forResource: String) -> Data? {
        
        let currentBundle = Bundle(for: type(of: self))
        if let pathForRecommendationMock = currentBundle.url(forResource: forResource, withExtension: "json") {
            do {
                return try Data(contentsOf: pathForRecommendationMock)
            } catch {
                XCTFail("Unable to convert \(pathForRecommendationMock) to Data.")
                return nil
            }
        } else {
            XCTFail("Unable to load \(forResource).json.")
            return nil
        }
        
    }
}


// MARK: - Helper Ex
extension FileManager {
    static var documentDirectoryURL: URL? {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        } catch {
            return nil //if there is an error return nil
        }
    }
}
