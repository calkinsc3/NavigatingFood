//
//  MealIterator.swift
//  NavigatingFood
//
//  Created by Bill Calkins on 7/15/22.
//
// Code to conform to AsyncSequence for meals

import Foundation



// MARK: AsynIteratorProtocol
//struct MealIterator: AsyncIteratorProtocol {
//
//    typealias Element = [Meal]
//
//    let categoryName: String
//
//    init(_ givenMeals: [Meal]) {
//        self.meals = givenMeals
//        self.index = Array<Meal>.startIndex
//    }
//
//    mutating func next() async throws -> Meal? {
//
//        //make sure we are not passed the end index
//        guard index < self.meals.endIndex else {
//            return nil
//        }
//
//        defer { self.index = self.meals.index(after: index) }
//
//
//        return Meal(givenMeal: self.meals[self.meals.startIndex...self.index])
//    }
//
//
//
//
//}
