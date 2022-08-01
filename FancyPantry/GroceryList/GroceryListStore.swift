//
//  GroceryListStore.swift
//  FancyPantry
//
//  Created by Matt Dailey on 7/27/22.
//

import Foundation


public protocol GroceryListStoreProtocol: ObservableObject {
    var groceries: [Grocery] { get }
    var appError: ErrorType? { get }
    var presentAlert: Bool { get }
    
    func fetchGroceries() async
    func updateGroceryActive(grocery: Grocery) async
}

class GroceryListStore: GroceryListStoreProtocol {
    
    // MARK: - Public properties
    
    @Published public var groceries: [Grocery] = []
    @Published public var appError: ErrorType? = nil
    @Published public var presentAlert: Bool = false
    
    // MARK: - Private properties
    private let apiClient: APIClientProtocol
    
    // MARK: - Initialization
    
    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    // MARK: - Public methods
    
    func fetchGroceries() async {
        do {
            let result = try await apiClient.fetchGroceries()
            await updateGroceries(groceries: result)
        } catch let error as APIError {
            await presentAlert(for: error)
        } catch {
            await presentAlert(for: .unknownError)
        }
    }
    
    func updateGroceryActive(grocery: Grocery) async {
        do {
            var tempGrocery = grocery
            tempGrocery.active = tempGrocery.active == 1 ? 0 : 1
            let result = try await apiClient.updateGrocery(grocery: tempGrocery)
            await updateGroceries(groceries: result)
        } catch let error as APIError {
            await presentAlert(for: error)
        } catch {
            await presentAlert(for: .unknownError)
        }
    }
    
    // MARK: - Private methods
    
    @MainActor
    private func updateGroceries(groceries: [Grocery]) {
        self.groceries = groceries
    }
    
    @MainActor
    private func presentAlert(for error: APIError) {
        presentAlert = true
        appError = ErrorType(error: error)
    }
}
