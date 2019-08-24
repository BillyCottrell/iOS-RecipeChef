//
//  MyRecipesCell.swift
//  RecipeChef
//
//  Created by Billy Cottrell on 09/08/2019.
//  Copyright © 2018-2019 Codexive. All rights reserved.
//

import UIKit

class MyRecipesCell: BaseCollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellId = "myRecipesCellId"
    
    var getIdeasController: GetIdeasController?
    
    var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 160, y: 100, width: 60, height: 60)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setImage(UIImage(named:"add"), for: .normal)
        button.backgroundColor = UIColor.rgb(red: 193, green: 67, blue: 72)
        button.addTarget(self, action: #selector(addButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func addButtonPressed(_ sender: UIButton!){
        print("hi")
    }
    
    /*func fetchRecipes(){
        ApiService.sharedInstance.fetchRecipes { (recipes: [Recipe]) in
            //print("this happens once")
            //print(recipes)
            self.recipes = recipes
            self.collectionView.reloadData()
        }
    }*/
    
    override func setupViews() {
        super.setupViews()
        //fetchRecipes()
        backgroundColor = .blue
        addSubview(collectionView)
        addSubview(addButton)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "H:[v0(60)]-8-|", views: addButton)
        addConstraintsWithFormat(format: "V:[v0(60)]-8-|", views: addButton)
        collectionView.register(MyRecipesMenuCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // returns the cell based on the index
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)// as! GetIdeasCell
        //cell.recipe = recipes[indexPath.item]
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
        //let recipe = RecipeLauncher()
        //recipe.getIdeasController = getIdeasController
        //recipe.showRecipe()
    }
}
