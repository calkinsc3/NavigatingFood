//
//  Errors.swift
//  FetchDesertReward
//
//  Created by Bill Calkins on 6/17/22.
//

import Foundation


enum FoodErrors: Error {
case network(description: String)
case decoding(description: String)
case urlError(description: String)
case apiError(description: String)
}

