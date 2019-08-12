//
//  ApiService.swift
//  RecipeChef
//
//  Created by Billy Cottrell on 09/08/2019.
//  Copyright © 2019 Billy Cottrell. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class ApiService: NSObject {
    
    static let sharedInstance = ApiService()
    
    func fetchRecipes(completion: @escaping ([Recipe]) -> ()) {
        var recipes = [Recipe]()
        Database.database().reference ().child("recipes").observe(.childAdded, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            guard let name = value?["name"] as? String else {return}
            guard let description = value?["description"] as? String else {return}
            guard let servings = value?["servings"] as? Int else {return}
            var ingredients : [Ingredient] = []
            for ing in value?["ingredients"] as! [NSDictionary] {
                guard let ingredientName = ing["ingredientName"] as? String else {return}
                guard let category = ing["category"] as? String else {return}
                guard let quantity = ing["quantity"] as? String else {return}
                guard let measurement = ing["measurement"] as? String else {return}
                guard let notes = ing["notes"] as? String else {return}
                let ingredient = Ingredient(ingredientName: ingredientName, category: category, quantity: quantity, measurement: measurement, notes: notes)
                ingredients.append(ingredient)
            }
            guard let preparationTime = value?["preparationTime"] as? Int else {return}
            guard let preparationMethod = value?["preparationMethod"] as? [String] else {return}
            guard let image = value?["image"] as? String else {return}
            guard let views = value?["views"] as? Int? else {return}
            guard let id = value?["id"] as? String? else {return}
            let recipe = Recipe(name: name,description: description, servings: servings, ingredients: ingredients, preparationTime: preparationTime, preparationMethod: preparationMethod, image: image, views: views, id: id)
            recipes.append(recipe)
            
            DispatchQueue.main.async {
                completion(recipes)
            }
            print(recipes[0].name)
        }, withCancel: nil)
    }
    
}
