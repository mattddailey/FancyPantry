//
//  GroceryListStore.swift
//  FancyPantry
//
//  Created by Matt Dailey on 7/27/22.
//

import Foundation

@MainActor
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
    
    // MARK: - Public methods
    
    func fetchGroceries() async {
        do {
            let result = try await APIClient.fetchGroceries()
            self.groceries = result
        } catch let error as APIError {
            presentAlert = true
            appError = ErrorType(error: error)
        } catch {
            presentAlert = true
            appError = ErrorType(error: .unknownError)
        }
    }
    
    func updateGroceryActive(grocery: Grocery) async {
        do {
            var tempGrocery = grocery
            tempGrocery.active = tempGrocery.active == 1 ? 0 : 1
            let result = try await APIClient.updateGrocery(grocery: tempGrocery)
            self.groceries = result
        } catch let error as APIError {
            presentAlert = true
            appError = ErrorType(error: error)
        } catch {
            presentAlert = true
            appError = ErrorType(error: .unknownError)
        }
    }
}
