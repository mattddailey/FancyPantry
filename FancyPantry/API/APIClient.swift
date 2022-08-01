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
    
    private let baseURL = "http://127.0.0.1:5000"
    
    private enum Endpoint {
        case groceryList(Int?)
        
        var path: String {
            switch self {
            case .groceryList(let id):
                if let id = id {
                    return "/groceryList/\(id)"
                } else {
                    return "/groceryList"
                }
            }
        }
        
    }
    
    private enum Method: String {
        case GET
        case PUT
    }
    
    
    
    private let session: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.session = urlSession
    }
    
    func fetchGroceries() async throws -> [Grocery] {
        return try await data(endpoint: .groceryList(nil), method: .GET)
    }
    
    func updateGrocery(grocery: Grocery) async throws -> [Grocery] {
        return try await request(endpoint: .groceryList(grocery.id), method: .PUT, body: grocery)
    }
    
    private func data<T: Codable>(endpoint: Endpoint, method: Method) async throws -> [T] {
        let path = "\(baseURL)\(endpoint.path)"
        guard let url = URL(string: path) else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw APIError.serverUpdateError
        }
        
        guard let decodedResponse = try? JSONDecoder().decode([T].self, from: data) else {
            throw APIError.decodeError
        }
        
        return decodedResponse
    }
     
    private func request<T: Codable>(endpoint: Endpoint, method: Method, body: T) async throws -> [T] {
        let path = "\(baseURL)\(endpoint.path)"
        guard let url = URL(string: path) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "\(method)"
        
        guard let encoded = try? JSONEncoder().encode(body) else {
            throw APIError.encodeError
        }
        request.httpBody = encoded
        
        let (data, response) = try await URLSession.shared.upload(for: request, from: encoded)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw APIError.serverUpdateError
        }
        
        guard let decodedResponse = try? JSONDecoder().decode([T].self, from: data) else {
            throw APIError.decodeError
        }
        
        return decodedResponse
    }
    
    
    
}
