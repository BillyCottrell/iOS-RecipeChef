//
//  RecipeController.swift
//  RecipeChef
//
//  Created by Billy Cottrell on 19/01/2019.
//  Copyright © 2018-2019 Codexive. All rights reserved.
//

import UIKit

class RecipeDetailController: UIViewController {
    
    var recipe : Recipe?

    @IBOutlet weak var preparationTime: UILabel!
    
    @IBOutlet weak var servings: UILabel!
    
    @IBOutlet weak var recipeName: UILabel!
    
    @IBOutlet weak var recipeDescription: UILabel!
    
    @IBOutlet weak var recipeImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let recipe = recipe {
            recipeImg.downloaded(from: recipe.image)
            preparationTime.text = String(format:"%d uur %d min", recipe.preparationTime/60, recipe.preparationTime%60)
            servings.text = String(recipe.servings)
            recipeName.text = recipe.name
            recipeDescription.text = recipe.description
            
        }
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
