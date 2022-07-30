//
//  MockAPIClient.swift
//  FancyPantryTests
//
//  Created by Matt Dailey on 7/30/22.
//

import Foundation
@testable import FancyPantry

class MockAPICLient: APIClientProtocol {
    var groceries: [Grocery] = [
        Grocery(id: 1,
                title: "Eggs",
                active: 0),
        Grocery(id: 2,
                title: "Apples",
                active: 1)
    ]
    var apiError: APIError?

    var fetchGroceriesExeuction: (() -> Void)?
    var updateGroceryExecution: ((Grocery) -> Void)?
    
    func fetchGroceries() async throws -> [Grocery] {
        fetchGroceriesExeuction?()
        if let apiError = apiError {
            throw apiError
        }
        return groceries
    }
    
    func updateGrocery(grocery: Grocery) async throws -> [Grocery] {
        updateGroceryExecution?(grocery)
        if let index = groceries.firstIndex(where: { $0.id == grocery.id }) {
            groceries[index] = grocery
        }
        if let apiError = apiError {
            throw apiError
        }
        return groceries
    }
    
    
}
