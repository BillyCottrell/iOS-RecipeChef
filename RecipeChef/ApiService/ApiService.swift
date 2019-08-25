//
//  ApiService.swift
//  RecipeChef
//
//  Created by Billy Cottrell on 09/08/2019.
//  Copyright © 2018-2019 Codexive. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class ApiService: NSObject {
    //Singleton notation
    static let sharedInstance = ApiService()
    
    // Fetches all recipes in the Firebase database
    // used escaping notation to pass recipes to where method was called
    func fetchRecipes(completion: @escaping ([Recipe]) -> ()) {
        // init recipes
        var recipes = [Recipe]()
        // get the reference of the recipes in the database and place data in snapshot
        Database.database().reference ().child("recipes").observe(.childAdded, with: { (snapshot) in
            // place all the data in a dictionary
            let value = snapshot.value as? NSDictionary
            // init the properties of the recipe
            guard let name = value?["name"] as? String else {return}
            guard let description = value?["description"] as? String else {return}
            guard let servings = value?["servings"] as? Int else {return}
            // init ingredients
            var ingredients : [Ingredient] = []
            // loop over the ingredients as a dictionary
            for ing in value?["ingredients"] as! [NSDictionary] {
                // init the properties of that ingredient
                guard let ingredientName = ing["ingredientName"] as? String else {return}
                // serves for ingredient grouping
                guard let category = ing["category"] as? String else {return}
                guard let quantity = ing["quantity"] as? String else {return}
                guard let measurement = ing["measurement"] as? String else {return}
                guard let notes = ing["notes"] as? String else {return}
                // create the ingredient with the previous properties
                let ingredient = Ingredient(ingredientName: ingredientName, category: category, quantity: quantity, measurement: measurement, notes: notes)
                // append that ingredient to the list of ingredients
                ingredients.append(ingredient)
            }
            // init the rest of the properties
            guard let preparationTime = value?["preparationTime"] as? Int else {return}
            guard let preparationMethod = value?["preparationMethod"] as? [String] else {return}
            // image is the url to the image
            guard let image = value?["image"] as? String else {return}
            guard let views = value?["views"] as? Int else {return}
            guard let id = value?["id"] as? String? else {return}
            // create that recipe with previous properties
            let recipe = Recipe(name: name,description: description, servings: servings, ingredients: ingredients, preparationTime: preparationTime, preparationMethod: preparationMethod, image: image, views: views, id: id)
            // append that recipe to the list of recipes
            recipes.append(recipe)
            // every time a recipe has been appended it sends it to the completion call so other functionality can move on while recipes are still loading
            DispatchQueue.main.async {
                completion(recipes)
            }
            // There are no errors thrown when network issues occur
        }, withCancel: nil)
    }
    
}
