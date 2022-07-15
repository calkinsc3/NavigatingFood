//
//  FoodCategoryModel.swift
//  NavigatingFood
//
//  Created by Bill Calkins on 6/24/22.
//
/*
 
 ┌─────────────┐
 │  Category   │
 │             │
 └─────────────┘
        │
        │   ┌─────────────┐
        │   │    Meals    │
        └──▶│             │
            └─────────────┘
                   │
                   │   ┌─────────────┐
                   │   │ MealDetails │
                   └──▶│             │
                       └─────────────┘
 */

import Foundation


import Foundation

// MARK: - FoodCategoryModel
struct FoodCategoryModel: Decodable {
    let categories: [Category]
    var sortedCategories: [Category] {
        categories.sorted(by: {$0.strCategory < $1.strCategory})
    }
    
    #if DEBUG
    static let `placeHolder` = Self(categories: [Category.beefPlaceholder, Category.chickenPlaceholder, Category.dessertPlaceholder])
    #endif
}

// MARK: - Category
struct Category: Decodable, Identifiable, Hashable, Equatable {
    let idCategory, strCategory: String
    let strCategoryThumb: String
    let strCategoryDescription: String
    
    var meals: [Meal]?
    
    var thumbnailURL: URL? {
        URL(string: strCategoryThumb)
    }
    
    var id: String {
        self.idCategory
    }
    
    #if DEBUG
    static let `beefPlaceholder` = Self(idCategory: "1", strCategory: "Beef", strCategoryThumb: "https://www.themealdb.com/images/category/beef.png", strCategoryDescription: "Beef is the culinary name for meat from cattle, particularly skeletal muscle. Humans have been eating beef since prehistoric times.[1] Beef is a source of high-quality protein and essential nutrients.[2]")
    static let `chickenPlaceholder` = Self(idCategory: "2", strCategory: "Chicken", strCategoryThumb: "https://www.themealdb.com/images/category/beef.png", strCategoryDescription: "Chicken is a type of domesticated fowl, a subspecies of the red junglefowl. It is one of the most common and widespread domestic animals, with a total population of more than 19 billion as of 2011.[1] Humans commonly keep chickens as a source of food (consuming both their meat and eggs) and, more rarely, as pets.")
    static let `dessertPlaceholder` = Self(idCategory: "3", strCategory: "Dessert", strCategoryThumb: "https://www.themealdb.com/images/category/beef.png", strCategoryDescription: "Dessert is a course that concludes a meal. The course usually consists of sweet foods, such as confections dishes or fruit, and possibly a beverage such as dessert wine or liqueur, however in the United States it may include coffee, cheeses, nuts, or other savory items regarded as a separate course elsewhere. In some parts of the world, such as much of central and western Africa, and most parts of China, there is no tradition of a dessert course to conclude a meal.\r\n\r\nThe term dessert can apply to many confections, such as biscuits, cakes, cookies, custards, gelatins, ice creams, pastries, pies, puddings, and sweet soups, and tarts. Fruit is also commonly found in dessert courses because of its naturally occurring sweetness. Some cultures sweeten foods that are more commonly savory to create desserts.")
    
    #endif
}
