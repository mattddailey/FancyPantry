//
//  GroceryListStore.swift
//  FancyPantry
//
//  Created by Matt Dailey on 7/27/22.
//

import Foundation

public protocol GroceryListStoreProtocol: ObservableObject {
    var groceries: [Grocery] { get }
    
    func fetchGroceries() async
    func updateGrocery(id: Int) async
}

class GroceryListStore: GroceryListStoreProtocol {
    // MARK: - Public properties
    @Published public var groceries: [Grocery] = []
    
    // MARK: - Public methods
    
    func fetchGroceries() async {
        do {
            let fetchResult = try await APIClient.fetchGroceries()
            await storeGroceries(fetchResult)
        } catch {
            print("Error fetching groceries: \(error)")
        }
    }
    
    func updateGrocery(id: Int) async {

    }
    
    // MARK: - Private methods
    @MainActor
    private func storeGroceries(_ groceries: [Grocery]) {
        self.groceries = groceries
    }
}
