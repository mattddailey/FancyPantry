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
                GroceryListItemView(grocery: groceryItem)
            }
        }
        .task {
            await groceryListStore.fetchGroceries()
        }
        .alert("Error", isPresented: $groceryListStore.presentAlert, presenting: groceryListStore.appError) { appError in
            Button("Ok") {}
        } message: { appError in
            Text(appError.error.localizedDescription)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GroceryListView()
            .environmentObject(GroceryListStore())
    }
}
