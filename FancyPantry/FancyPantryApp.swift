//
//  FancyPantryApp.swift
//  FancyPantry
//
//  Created by Matt Dailey on 7/27/22.
//

import SwiftUI

@main
struct FancyPantryApp: App {
    
    @StateObject var groceryListStore = GroceryListStore()
    
    var body: some Scene {
        WindowGroup {
            GroceryListView()
                .environmentObject(groceryListStore)
        }
    }
}
