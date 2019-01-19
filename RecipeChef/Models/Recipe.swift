//
//  Recipe.swift
//  RecipeChef
//
//  Created by Billy Cottrell on 04/12/2018.
//  Copyright © 2018 Billy Cottrell. All rights reserved.
//

import Foundation

class Recept {
    var name: String
    var description: String
    var servings: Int
    var ingredients: [Ingredient]
    var preparationTime: Int
    var preparationMethod: [String]
    var image: String
    var views: Int
    var id: String
    init(name:String,description:String,servings:Int, ingredients:[Ingredient], preparationTime:Int,preparationMethod:[String],image:String,views:Int?, id:String?){
        self.name = name
        self.description = description
        self.servings = servings
        self.ingredients = ingredients
        self.preparationTime = preparationTime
        self.preparationMethod = preparationMethod
        self.image = image
        self.views = views ?? 0
        self.id = id ?? ""
    }
}
