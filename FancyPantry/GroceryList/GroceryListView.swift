//
//  GroceryListView.swift
//  FancyPantry
//
//  Created by Matt Dailey on 7/27/22.
//

import SwiftUI

struct GroceryListView<T>: View where T: GroceryListStoreProtocol  {
    @EnvironmentObject var groceryListStore: T
    
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
        GroceryListView<GroceryListStore>()
            .environmentObject(GroceryListStore())
    }
}
