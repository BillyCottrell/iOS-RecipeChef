//
//  BaseCollectionViewCell.swift
//  RecipeChef
//
//  Created by Billy Cottrell on 03/08/2019.
//  Copyright © 2018-2019 Codexive. All rights reserved.
//

import Foundation
import UIKit

// this is used so init doesn't show up in every cell
class BaseCollectionViewCell: UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews(){}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
