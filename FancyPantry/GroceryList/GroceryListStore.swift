//
//  GroceryListStore.swift
//  FancyPantry
//
//  Created by Matt Dailey on 7/27/22.
//

import Foundation

public protocol GroceryListStoreProtocol: ObservableObject {
    var groceryList: [String] { get }
}

public final class GroceryListStore: GroceryListStoreProtocol {
    @Published public var groceryList: [String] = ["Eggs", "Butter"]
}
