//
//  APIClient.swift
//  FancyPantry
//
//  Created by Matt Dailey on 7/29/22.
//

import Foundation

protocol APIClientProtocol {
    func fetchGroceries() async throws -> [Grocery]
    func updateGrocery(grocery: Grocery) async throws -> [Grocery]
}

class APIClient: APIClientProtocol {
    
    static let shared = APIClient()
    
    private let apiURL = "http://127.0.0.1:5000"
    private let session: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.session = urlSession
    }
    
    func fetchGroceries() async throws -> [Grocery] {
        guard let url = URL(string: apiURL + "/groceryList") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw APIError.serverFetchError
        }
        
        guard let decodedResponse = try? JSONDecoder().decode([Grocery].self, from: data) else {
            throw APIError.decodeError
        }
        
        return decodedResponse
    }
    
    func updateGrocery(grocery: Grocery) async throws -> [Grocery] {
        guard let url = URL(string: apiURL + "/groceryList/\(grocery.id)") else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        
        guard let encoded = try? JSONEncoder().encode(grocery) else {
            print("Failed to encode order")
            throw APIError.encodeError
        }
        request.httpBody = encoded
        
        let (data, response) = try await URLSession.shared.upload(for: request, from: encoded)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw APIError.serverUpdateError
        }
                
        guard let decodedResponse = try? JSONDecoder().decode([Grocery].self, from: data) else {
            throw APIError.decodeError
        }

        return decodedResponse
    }
    
}
