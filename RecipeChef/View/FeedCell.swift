//
//  FeedCell.swift
//  RecipeChef
//
//  Created by Billy Cottrell on 09/08/2019.
//  Copyright © 2018-2019 Codexive. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FeedCell: BaseCollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // this contains all recipes
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    // recipe cell id for the collectionview
    let cellId = "feedcellId"
    
    // list of recipes
    var recipes = [Recipe]()
    
    // parent controller for statusbar updates
    var getIdeasController: GetIdeasController?
    
    // fetches the recipes and reloads the data async
    func fetchRecipes(){
        ApiService.sharedInstance.fetchRecipes { (recipes: [Recipe]) in
            self.recipes = recipes
            self.collectionView.reloadData()
        }
    }
    
    override func setupViews() {
        super.setupViews()
        // fetches all recipes
        fetchRecipes()
        // ads the collectionview
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        collectionView.register(RecipeCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // returns the cell based on the index
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! RecipeCell
        cell.recipe = recipes[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // returns the size of a cell
        let height = (frame.width - 16 - 16)*9/16
        return CGSize.init(width: frame.width, height: height+16+68)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // returns the spacing between cells
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // when a recipe is selected creates the launcher
        let recipeLauncher = RecipeLauncher()
        // passes the recipe to the launcher
        recipes[indexPath.item].views = recipes[indexPath.item].views + 1
        recipeLauncher.recipe = recipes[indexPath.item]
        // sets the controller
        recipeLauncher.getIdeasController = getIdeasController
        // shows the recipe details
        recipeLauncher.showRecipe()
        // updates the recipe view property 
        let ref = Database.database().reference ().child("recipes").child(recipeLauncher.recipe!.id!)
        var recipeUpdates = [String:Any]()
        recipeUpdates["views"] = recipeLauncher.recipe?.views
        ref.updateChildValues(recipeUpdates)
    }
    
    
}
