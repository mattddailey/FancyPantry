//
//  GroceryListView.swift
//  FancyPantry
//
//  Created by Matt Dailey on 7/27/22.
//

import SwiftUI

struct GroceryListView: View  {
    @EnvironmentObject var groceryListStore: GroceryListStore
    
    var body: some View {
        List {
            ForEach(groceryListStore.groceries) { groceryItem in
                GroceryListItemView(id: groceryItem.id, title: groceryItem.title, isActive: groceryItem.isActive)
            }
        }
        .task {
            await groceryListStore.fetchGroceries()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GroceryListView()
            .environmentObject(GroceryListStore())
    }
}
