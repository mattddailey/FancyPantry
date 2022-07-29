//
//  APIClient.swift
//  FancyPantry
//
//  Created by Matt Dailey on 7/29/22.
//

import Foundation

class APIClient {
    
    static let apiURL = "http://127.0.0.1:5000"
    
    enum APIError: Error {
        case invalidURL
        case fetchError
        case decodeError
    }
    
    static func fetchGroceries() async throws -> [Grocery] {
        guard let url = URL(string: apiURL + "/groceryList") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw APIError.fetchError
        }
        
        guard let decodedResponse = try? JSONDecoder().decode([Grocery].self, from: data) else {
            throw APIError.decodeError
        }
        
        return decodedResponse
    }
    
    static func updateGrocery(id: Int) {
        
    }
    
}
