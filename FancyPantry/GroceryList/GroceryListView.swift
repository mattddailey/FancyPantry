//
//  GroceryListView.swift
//  FancyPantry
//
//  Created by Matt Dailey on 7/27/22.
//

import SwiftUI

struct GroceryListView: View {
    @EnvironmentObject var groceryListStore: GroceryListStore
    
    var body: some View {
        List {
            ForEach(groceryListStore.groceryList, id: \.self) { groceryItem in
                GroceryListItemView(item: groceryItem)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GroceryListView()
            .environmentObject(GroceryListStore())
    }
}
