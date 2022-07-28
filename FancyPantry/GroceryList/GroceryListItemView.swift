//
//  GroceryListItemView.swift
//  FancyPantry
//
//  Created by Matt Dailey on 7/27/22.
//

import SwiftUI

struct GroceryListItemView: View {
    
    var item: String
    
    var body: some View {
        Text(item)
    }
}

struct GroceryListItemView_Previews: PreviewProvider {
    static var previews: some View {
        GroceryListItemView(item: "Test")
    }
}
