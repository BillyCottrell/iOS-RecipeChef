//
//  IngredientCell.swift
//  RecipeChef
//
//  Created by Billy Cottrell on 24/08/2019.
//  Copyright © 2019 Billy Cottrell. All rights reserved.
//

import UIKit

class IngredientCell: BaseCollectionViewCell {
    var ingredient: Ingredient? {
        didSet {
            var ing = ""
            if let quantity = ingredient?.quantity {
                ing += quantity
            }
            if let measurement = ingredient?.measurement {
                ing += measurement
            }
            ing += ingredient!.ingredientName
            if let notes = ingredient?.notes {
                ing += notes
            }
            ingredientLabel.text = ing
        }
    }
    
    let ingredientLabel = UILabel()
    
    override func setupViews() {
        super.setupViews()
        addSubview(ingredientLabel)
        addConstraintsWithFormat(format: "H:|[v0]|", views: ingredientLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: ingredientLabel)
    }
}
