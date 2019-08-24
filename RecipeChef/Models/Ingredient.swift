//
//  Ingredient.swift
//  RecipeChef
//
//  Created by Billy Cottrell on 19/01/2019.
//  Copyright © 2018-2019 Codexive. All rights reserved.
//

import Foundation

struct Ingredient : Codable{
    var ingredientName: String
    var category: String
    var quantity: String?
    var measurement: String?
    var notes: String?
    enum CodingKeys: String, CodingKey {
        case ingredientName
        case category
        case quantity
        case measurement
        case notes
    }
}
