//
//  BaseTableViewCell.swift
//  RecipeChef
//
//  Created by Billy Cottrell on 24/08/2019.
//  Copyright © 2019 Billy Cottrell. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupViews()
    }
    
    func setupViews(){}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
