//
//  PreparationMethodCell.swift
//  RecipeChef
//
//  Created by Billy Cottrell on 24/08/2019.
//  Copyright © 2019 Billy Cottrell. All rights reserved.
//

import UIKit

class PreparationMethodCell: BaseCollectionViewCell {
    
    var preparationMethod: String? {
        didSet {
            prepMethodLabel.text = preparationMethod
        }
    }
    
    let prepMethodLabel = UILabel()
    
    override func setupViews() {
        super.setupViews()
        addSubview(prepMethodLabel)
        addConstraintsWithFormat(format: "H:|[v0]|", views: prepMethodLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: prepMethodLabel)
    }

}
