//
//  Recipe.swift
//  RecipeChef
//
//  Created by Billy Cottrell on 04/12/2018.
//  Copyright © 2018-2019 Codexive. All rights reserved.
//

import Foundation

// recipe is a codable object with an enum of codingKeys which is needed when working with firebase
struct Recipe : Codable {
    var name: String
    var description: String
    var servings: Int
    var ingredients: [Ingredient]
    var preparationTime: Int
    var preparationMethod: [String]
    var image: String
    var views: Int
    var id: String?
    enum CodingKeys: String, CodingKey{
        case name
        case description
        case servings
        case ingredients
        case preparationTime
        case preparationMethod
        case image
        case views
        case id
    }
}
