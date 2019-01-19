//
//  Ingredient.swift
//  RecipeChef
//
//  Created by Billy Cottrell on 19/01/2019.
//  Copyright © 2019 Billy Cottrell. All rights reserved.
//

import Foundation

class Ingredient {
    var ingredientName: String
    var category: String
    var quantity: String
    var measurement: String
    var notes: String
    init(ingredientName: String,category:String, quantity:String?, measurement:String?, notes:String?){
        self.ingredientName = ingredientName
        self.category = category
        self.quantity = quantity ?? ""
        self.measurement = measurement ?? ""
        self.notes = notes ?? ""
    }
}
