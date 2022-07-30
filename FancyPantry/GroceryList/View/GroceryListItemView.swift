//
//  GroceryListItemView.swift
//  FancyPantry
//
//  Created by Matt Dailey on 7/27/22.
//

import SwiftUI

struct GroceryListItemView: View {
    
    @EnvironmentObject var groceryListStore: GroceryListStore
    
    var grocery: Grocery
    
    var body: some View {
        
        Button(action: {
            Task {
                await groceryListStore.updateGroceryActive(grocery: self.grocery)
            }
        }, label: {
            Text(grocery.title)
                .foregroundColor(grocery.isActive ? .black : .gray)
                .strikethrough(!grocery.isActive, color: .gray)
                .opacity(grocery.isActive ? 1 : 0.4)
        })
    }
}

struct GroceryListItemView_Previews: PreviewProvider {
    static var grocery: Grocery = Grocery(id: 1,
                                          title: "Apple",
                                          active: 1)
    
    static var previews: some View {
        GroceryListItemView(grocery: grocery)
    }
}
