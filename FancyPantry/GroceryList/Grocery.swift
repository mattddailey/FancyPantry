//
//  Grocery.swift
//  FancyPantry
//
//  Created by Matt Dailey on 7/29/22.
//

import Foundation


public struct Grocery: Decodable, Hashable, Identifiable {
    public let id: Int
    let title: String
    let active: Int
    
    var isActive: Bool {
        return active == 1
    }
}
