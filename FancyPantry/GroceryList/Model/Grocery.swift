//
//  Grocery.swift
//  FancyPantry
//
//  Created by Matt Dailey on 7/29/22.
//

import Foundation


public struct Grocery: Codable, Hashable, Identifiable, Equatable {
    public let id: Int
    
    var title: String
    var active: Int
    
    var isActive: Bool {
        return active == 1
    }
}
