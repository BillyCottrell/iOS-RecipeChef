//
//  IngredientLauncher.swift
//  RecipeChef
//
//  Created by Billy Cottrell on 25/08/2019.
//  Copyright © 2019 Billy Cottrell. All rights reserved.
//

import UIKit

class IngredientLauncher: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var ingredients: [Ingredient]? {
        didSet {
            for ingredient in ingredients! {
                if !ingredient.category.isEmpty {
                    if !listOfCategories.contains(ingredient.category) {
                        numberOfCategories += 1
                        listOfCategories.append(ingredient.category)
                        amountOfRowsInCategory.append(1)
                    } else {
                        amountOfRowsInCategory[listOfCategories.index(of: ingredient.category)!] += 1
                    }
                    
                }
            }
            ingredientTable.reloadData()
        }
    }
    var numberOfCategories: Int = 0
    var listOfCategories: [String] = []
    var amountOfRowsInCategory: [Int] = []
    var getIdeasController: GetIdeasController?
    var view: UIView?
    var title: UILabel = {
        let label = UILabel()
        label.text = "Ingredients"
        label.textColor = .white
        label.backgroundColor = UIColor.rgb(red: 193, green: 67, blue: 72)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 21.0)
        return label
    }()
    lazy var ingredientTable: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        return tv
    }()
    var backButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 160, y: 100, width: 40, height: 40)
        button.clipsToBounds = true
        button.setImage(UIImage(named:"back"), for: .normal)
        return button
    }()
    let ingredientCellId = "ingredientCellId"
    var mySelf: IngredientLauncher?
    
    func showIngredients(){
        mySelf = self
        if let keyWindow = UIApplication.shared.keyWindow {
            view = UIView(frame: keyWindow.frame)
            view?.backgroundColor = UIColor.white
            view?.frame = CGRect(x: keyWindow.frame.width-10, y: 0, width: 10, height: 10)
            setupView(view: view!, keyWindow: keyWindow)
            keyWindow.addSubview(view!)
            animateView(options: .curveEaseOut, keyWindow: keyWindow)
        }
    }
    
    func setupView(view:UIView, keyWindow: UIWindow) {
        backButton.addTarget(mySelf, action: #selector(minimizeLauncher(_:)), for: .touchUpInside)
        view.addSubview(ingredientTable)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: ingredientTable)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views:ingredientTable)
        
        let headerView = UIView()
        headerView.addSubview(title)
        headerView.addSubview(backButton)
        headerView.addConstraintsWithFormat(format: "H:|[v0]", views: backButton)
        headerView.addConstraintsWithFormat(format: "V:|[v0]", views: backButton)
        headerView.addConstraintsWithFormat(format: "H:|[v0]|", views: title)
        headerView.addConstraintsWithFormat(format: "V:|[v0]|", views: title)
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
        let height: CGFloat = 48
        let width = size.width
        headerView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        ingredientTable.tableHeaderView = headerView
        let footerView = UIView()
        footerView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        ingredientTable.tableFooterView = footerView
        ingredientTable.dataSource = mySelf
        ingredientTable.delegate = mySelf
        ingredientTable.tableHeaderView?.backgroundColor = UIColor.rgb(red: 193, green: 67, blue: 72)
        ingredientTable.translatesAutoresizingMaskIntoConstraints = false
        ingredientTable.rowHeight = UITableView.automaticDimension
        ingredientTable.estimatedRowHeight = 600
        ingredientTable.reloadData()
        ingredientTable.register(UITableViewCell.self, forCellReuseIdentifier: ingredientCellId)
        
    }
    
    @objc func minimizeLauncher(_ sender: UIButton!) {
        if let keyWindow = UIApplication.shared.keyWindow {
            animateView(options: .curveEaseIn, keyWindow: keyWindow)
        }
    }
    
    func animateView(options: UIView.AnimationOptions, keyWindow: UIWindow) {
        let opening = options == UIView.AnimationOptions.curveEaseOut
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: options, animations: {
            self.view!.frame = opening ? keyWindow.frame :  CGRect(x: keyWindow.frame.width, y: 0, width: 0, height: keyWindow.frame.height)
        }, completion: {(completedAnimation) in
            self.getIdeasController?.hideStatusBar(hidden: true)
        })
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = listOfCategories[section] + ":"
        label.setFontSize(size: 18)
        let view = UIView()
        view.addSubview(label)
        view.addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: label)
        if(section==0){
            view.addConstraintsWithFormat(format: "V:|-16-[v0(20)]-16-|", views: label)
        } else {
            view.addConstraintsWithFormat(format: "V:|[v0(20)]-16-|", views: label)
        }
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfCategories
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return amountOfRowsInCategory[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientTable.dequeueReusableCell(withIdentifier: ingredientCellId, for: indexPath)
        let ingredient: Ingredient?
        var ingreds: [Ingredient] = []
        for ingred in ingredients! {
            if listOfCategories[indexPath.section] == ingred.category {
                ingreds.append(ingred)
            }
        }
        ingredient = ingreds[indexPath.row]
        var ing = ""
        if let quantity = ingredient?.quantity {
            if !quantity.isEmpty {
                ing += quantity + " "
            }
        }
        if let measurement = ingredient?.measurement {
            if !measurement.isEmpty {
                ing += measurement + " "
            }
        }
        ing += ingredient!.ingredientName
        if let notes = ingredient?.notes {
            if !notes.isEmpty {
                ing += " " + notes
            }
        }
        print(ing)
        cell.textLabel?.text = ing
        cell.textLabel?.numberOfLines = 0
        cell.addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: cell.textLabel!)
        cell.addConstraintsWithFormat(format: "V:|[v0]|", views: cell.textLabel!)
        return cell
    }
    
}
