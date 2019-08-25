//
//  RecipeCell.swift
//  RecipeChef
//
//  Created by Billy Cottrell on 16/07/2019.
//  Copyright © 2018-2019 Codexive. All rights reserved.
//

import Foundation
import UIKit


class RecipeCell: BaseCollectionViewCell {
    
    var recipe: Recipe? {
        didSet {
            //when recipe has been set, set the textViews text and download the recipe image
            recipeNameTextView.text = recipe?.name
            if let recipeImage = recipe?.image {
                thumbnailImageView.downloaded(from: recipeImage)
            }
        }
    }
    // The recipe image view
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // Text view for recipe name
    let recipeNameTextView: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()
    
    // view as separator between cells
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    override func setupViews(){
        super.setupViews()
        // create recipe name view as a container for the recipe name text view so it covers the bottom of the recipe image
        let recipeNameView = UIView()
        recipeNameView.addSubview(recipeNameTextView)
        recipeNameView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        recipeNameView.addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: recipeNameTextView)
        recipeNameView.addConstraintsWithFormat(format: "V:|[v0]|", views: recipeNameTextView)
        
        addSubview(thumbnailImageView)
        addSubview(separatorView)
        addSubview(recipeNameView)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: thumbnailImageView)
        addConstraintsWithFormat(format: "V:|-8-[v0]-8-[v1(1)]|", views: thumbnailImageView, separatorView)
        addConstraintsWithFormat(format: "V:[v0(44)]-9-|", views: recipeNameView)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: recipeNameView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: separatorView)
    }
    
}
