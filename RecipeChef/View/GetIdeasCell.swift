//
//  GetIdeasCell.swift
//  RecipeChef
//
//  Created by Billy Cottrell on 16/07/2019.
//  Copyright © 2019 Billy Cottrell. All rights reserved.
//

import Foundation
import UIKit

class GetIdeasCell: BaseCell {
    
    var recipe: Recipe? {
        didSet {
            recipeNameTextView.text = recipe?.name
            if let recipeImage = recipe?.image {
                thumbnailImageView.downloaded(from: recipeImage)
            }
        }
    }
    
    //@IBOutlet weak var recipeimg: UIImageView!
    //@IBOutlet weak var recipelbl: UILabel!
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let recipeNameTextView: UILabel = {
        let label = UILabel()
        label.text = "First Recipe i made whooo, hopefully this works like it should"
        //label.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        label.textColor = UIColor.white
        //label.padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()
    /*let recipeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        label.textColor = UIColor.white
        label.text = "First Recipe i made whooo"
        return label
    }()*/
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    override func setupViews(){
        super.setupViews()
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
