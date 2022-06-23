//
//  DessertDetailsViewModel.swift
//  FetchDesertReward
//
//  Created by Bill Calkins on 6/21/22.
//

import Foundation
import os

final class DessertDetailsViewModel: ObservableObject {
    
    @Published var desertDetail: MealDetail?
    
    @MainActor
    func getDesertDetails(withMealId mealID: String) async {
        let desertFetcher = DessertFetcher()
        do {
            self.desertDetail = try await desertFetcher.fetchDesertDetails(withMealId: mealID)
        } catch {
            Log.networkLogger.error("Unable to retrieve desert details from API")
        }
    }
    
}
