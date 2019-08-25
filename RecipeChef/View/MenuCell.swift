//
//  MenuCell.swift
//  RecipeChef
//
//  Created by Billy Cottrell on 03/08/2019.
//  Copyright © 2018-2019 Codexive. All rights reserved.
//

import Foundation
import UIKit

class MenuCell: BaseCollectionViewCell{
    // contains the image of the navigationItem
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named:"idea")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor.rgb(red: 91, green: 14, blue: 13)
        return iv
    }()
    
    // styles the image when highlighted
    override var isHighlighted: Bool{
        didSet{
            imageView.tintColor = isHighlighted ? UIColor.white : UIColor.rgb(red: 91, green: 14, blue: 13)
        }
    }

    // styles the image when selected
    override var isSelected: Bool{
        didSet{
            imageView.tintColor = isSelected ? UIColor.white : UIColor.rgb(red: 91, green: 14, blue: 13)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        addSubview(imageView)
        addConstraintsWithFormat(format: "H:[v0(28)]", views: imageView)
        addConstraintsWithFormat(format: "V:[v0(28)]", views: imageView)
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
