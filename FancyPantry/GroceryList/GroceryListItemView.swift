//
//  GroceryListItemView.swift
//  FancyPantry
//
//  Created by Matt Dailey on 7/27/22.
//

import SwiftUI

struct GroceryListItemView: View {
    
    @EnvironmentObject var groceryListStore: GroceryListStore
    
    var id: Int
    var title: String
    @State var isActive: Bool
    
    var body: some View {
        
        Button(action: {
            self.isActive = !self.isActive
            Task {
                await groceryListStore.updateGrocery(id: id)
            }
        }, label: {
            Text(title)
                .foregroundColor(isActive ? .black : .gray)
                .strikethrough(!isActive, color: .gray)
                .opacity(isActive ? 1 : 0.4)
        })
    }
}

struct GroceryListItemView_Previews: PreviewProvider {
    static var previews: some View {
        GroceryListItemView(id: 1, title: "Test", isActive: false)
    }
}
