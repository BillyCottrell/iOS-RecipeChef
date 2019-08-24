//
//  RecipeLauncher.swift
//  RecipeChef
//
//  Created by Billy Cottrell on 12/08/2019.
//  Copyright © 2018-2019 Codexive. All rights reserved.
//

import UIKit

class RecipeLauncher: NSObject {
    
    var getIdeasController: GetIdeasController?
    var recipe: Recipe? {
        didSet {
            if let recipeImage = recipe?.image {
                recipeImageView.downloaded(from: recipeImage)
            }
            recipeNameLabel.text = recipe!.name
            recipeViewsTextView.text = String(recipe!.views) + " views"
            recipeServingsTextView.text = String(recipe!.servings) + " servings"
            var preparationTimeMin: Int = recipe!.preparationTime
            var preparationTimeHour: Int = 0
            if(preparationTimeMin>=60){
                preparationTimeHour = preparationTimeMin / 60
                preparationTimeMin = preparationTimeMin % 60
                recipePrepTimeTextView.text = String(preparationTimeHour) + " hour(s) " + String(preparationTimeMin) + " min(s)"
            } else {
                recipePrepTimeTextView.text = String(preparationTimeMin) + " min(s)"
            }
            
        }
    }
    var view: UIView?
    var mySelf: RecipeLauncher?
    var backButton = UIButton()
    var closeButton = UIButton()
    var enlargeButton = UIButton()
    var recipeImageView: UIImageView = {
        let imageView : UIImageView
        let keyWindow = UIApplication.shared.keyWindow
        let imageFrame = CGRect(x: 0, y: 0, width: keyWindow!.frame.width, height: keyWindow!.frame.width * 9 / 16)
        imageView = UIImageView(frame: imageFrame)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    var recipeImageViewSizingview: UIView = {
        let keyWindow = UIApplication.shared.keyWindow
        let view: UIView
        let viewframe = CGRect(x: 0, y: 0, width: keyWindow!.frame.width, height: keyWindow!.frame.width * 9 / 16)
        view = UIView(frame: viewframe)
        return view
    }()
    var recipeNameLabel: UILabel = {
        let label = UILabel()
        //label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()
    var recipeViewsTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        //textView.adjustsFontForContentSizeCategory = true
        textView.textColor = UIColor.darkGray
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        return textView
    }()
    let separatorView1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 200, green: 200, blue: 200)
        return view
    }()
    let separatorView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 200, green: 200, blue: 200)
        return view
    }()
    let recipePrepTimeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "add"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.black
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    let recipeServingsImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "add"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.black
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    let recipePrepTimeTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .center
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .darkGray
        return textView
    }()
    let recipeServingsTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .center
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .darkGray
        return textView
    }()
    /*lazy var ingredientsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .blue
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()*/
    let ingredientsTableView = UITableView()
    let ingredientCellId = "ingredientCellId"
    /*lazy var prepMethodsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .red
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()*/
    let prepMethodsTableView = UITableView()
    let prepMethodCellId = "prepMethodCellId"
    var minimized: Bool?
    
    func showRecipe(){
        mySelf = self
        print("showing recipe launcher")
        if let keyWindow = UIApplication.shared.keyWindow {
            view = UIView(frame: keyWindow.frame)
            view?.backgroundColor = UIColor.white
            view?.frame = CGRect(x: keyWindow.frame.width-10, y: keyWindow.frame.height-10, width: 10, height: 10)
            setupView(view: view!, keyWindow: keyWindow)
            keyWindow.addSubview(view!)
            animateView(options: .curveEaseOut, keyWindow: keyWindow)
        }
    }
    
    func animateView(options: UIView.AnimationOptions, keyWindow: UIWindow) {
        let opening = options == UIView.AnimationOptions.curveEaseOut
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: options, animations: {
            self.view?.frame = opening ? keyWindow.frame : CGRect(x: keyWindow.frame.width-255, y: keyWindow.frame.height-(250*9/16)-5, width: 250, height: 250*9/16)
            self.backButton.isHidden = opening ? false : true
            self.recipeImageView.frame = opening ? CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: keyWindow.frame.width * 9 / 16) : CGRect(x: 0, y: 0, width: 250, height: 250*9/16)
            self.recipeImageView.updateConstraints()
            self.minimized = opening ? false : true
            self.recipeImageViewSizingview.frame = opening ? CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: keyWindow.frame.width * 9 / 16) : CGRect(x: 0, y: 0, width: 250, height: 250*9/16)
        }, completion: {(completedAnimation) in
            self.getIdeasController?.hideStatusBar(hidden: opening)
        })
    }
    
    func setupView(view:UIView, keyWindow: UIWindow){
        setupBackButton()
        //recipeNameLabel.text = recipe?.name
        recipeViewsTextView.setFontSize(size: 15)
        //recipeServingsTextView.text = String(recipe!.servings) + " servings"
        //recipePrepTimeTextView.text = String(recipe!.preparationTime) + " min"
        let servingsSubView = UIView()
        servingsSubView.addSubview(recipeServingsImageView)
        servingsSubView.addSubview(recipeServingsTextView)
        let prepTimeSubView = UIView()
        prepTimeSubView.addSubview(recipePrepTimeImageView)
        prepTimeSubView.addSubview(recipePrepTimeTextView)
        // 16 x 9 is the most used aspect ratio for videos
        view.addSubview(recipeImageView)
        view.addSubview(recipeImageViewSizingview)
        view.addSubview(backButton)
        view.addSubview(recipeNameLabel)
        view.addSubview(recipeViewsTextView)
        view.addSubview(separatorView1)
        view.addSubview(prepTimeSubView)
        view.addSubview(servingsSubView)
        view.addSubview(separatorView2)
        view.addSubview(ingredientsTableView)
        view.addSubview(prepMethodsTableView)
        setupMinimizedView()
        view.addConstraintsWithFormat(format: "H:|-16-[v0(40)]", views: backButton)
        view.addConstraintsWithFormat(format: "V:|-16-[v0(40)]", views: backButton)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: recipeImageView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(==keyview)]-0-[v1(44)]-28-[v2(1)]-8-[v3(44)]-8-[v5(1)]-8-[v6]-8-[v7]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":recipeImageView, "v1":recipeNameLabel, "keyview":recipeImageViewSizingview, "v2":separatorView1, "v3": prepTimeSubView, "v5": separatorView2, "v6": ingredientsTableView, "v7": prepMethodsTableView]))
        view.addConstraintsWithFormat(format: "V:[v0(1)]-8-[v1(44)]-8-[v2(1)]", views: separatorView1, servingsSubView, separatorView2)
        view.addConstraintsWithFormat(format: "H:|[v0(==v1)]-[v1]|", views: prepTimeSubView, servingsSubView)
        view.addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: recipeNameLabel)
        subTitleConstraints(view: view, keyWindow: keyWindow)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: separatorView1)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: separatorView2)
        
        prepTimeSubView.addConstraintsWithFormat(format: "H:[v0(20)]", views: recipePrepTimeImageView)
        prepTimeSubView.addConstraintsWithFormat(format: "H:|[v0]|", views: recipePrepTimeTextView)
        prepTimeSubView.addConstraintsWithFormat(format: "V:|[v0(20)]-[v1(24)]|", views: recipePrepTimeImageView, recipePrepTimeTextView)
        //recipePrepTimeImageView.center = prepTimeSubView.center
        //recipeServingsImageView.center = servingsSubView.center
        prepTimeSubView.addConstraint(NSLayoutConstraint(item: recipePrepTimeImageView, attribute: .centerY, relatedBy: .equal, toItem: prepTimeSubView, attribute: .centerY, multiplier: 1, constant: 0))
        prepTimeSubView.addConstraint(NSLayoutConstraint(item: recipePrepTimeImageView, attribute: .centerX, relatedBy: .equal, toItem: prepTimeSubView, attribute: .centerX, multiplier: 1, constant: 0))
        servingsSubView.addConstraintsWithFormat(format: "H:[v0(20)]", views: recipeServingsImageView)
        servingsSubView.addConstraintsWithFormat(format: "H:|[v0]|", views: recipeServingsTextView)
        servingsSubView.addConstraintsWithFormat(format: "V:|[v0(20)]-[v1(24)]|", views: recipeServingsImageView, recipeServingsTextView)
        servingsSubView.addConstraint(NSLayoutConstraint(item: recipeServingsImageView, attribute: .centerY, relatedBy: .equal, toItem: servingsSubView, attribute: .centerY, multiplier: 1, constant: 0))
        servingsSubView.addConstraint(NSLayoutConstraint(item: recipeServingsImageView, attribute: .centerX, relatedBy: .equal, toItem: servingsSubView, attribute: .centerX, multiplier: 1, constant: 0))
        //view.addConstraintsWithFormat(format: "H:[v0(20)]-[v1(20)]", views: recipePrepTimeImageView, recipeServingsImageView)
        //view.addConstraintsWithFormat(format: "H:|[v0(==v1)]-[v1(==v0)]|", views: recipePrepTimeTextView, recipeServingsTextView)
        ingredientsTableView.backgroundColor = .blue
        ingredientsTableView.translatesAutoresizingMaskIntoConstraints = false
        ingredientsTableView.delegate = mySelf
        ingredientsTableView.dataSource = mySelf
        prepMethodsTableView.backgroundColor = .red
        prepMethodsTableView.translatesAutoresizingMaskIntoConstraints = false
        prepMethodsTableView.delegate = mySelf
        prepMethodsTableView.dataSource = mySelf
        ingredientsTableView.reloadData()
        prepMethodsTableView.reloadData()
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: ingredientsTableView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: prepMethodsTableView)
        
        ingredientsTableView.register(IngredientCell.self, forCellReuseIdentifier: ingredientCellId)
        prepMethodsTableView.register(PreparationMethodCell.self, forCellReuseIdentifier: prepMethodCellId)
    }
    
    func setupBackButton(){
        backButton.frame = CGRect(x: 160, y: 100, width: 40, height: 40)
        backButton.layer.cornerRadius = 0.5 * backButton.bounds.size.width
        backButton.clipsToBounds = true
        //backButton.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        backButton.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        backButton.setImage(UIImage(named:"add"), for: .normal)
        backButton.addTarget(mySelf, action: #selector(minimizeRecipe(_:)), for: .touchUpInside)
    }
    
    func subTitleConstraints(view: UIView, keyWindow: UIWindow) {
        //top
        view.addConstraint(NSLayoutConstraint(item: recipeViewsTextView, attribute: .top, relatedBy: .equal, toItem: recipeNameLabel, attribute: .bottom, multiplier: 1, constant: 0))
        //left
        view.addConstraint(NSLayoutConstraint(item: recipeViewsTextView, attribute: .left, relatedBy: .equal, toItem: recipeNameLabel, attribute: .left, multiplier: 1, constant: 4))
        //right
        view.addConstraint(NSLayoutConstraint(item: recipeViewsTextView, attribute: .right, relatedBy: .equal, toItem: recipeNameLabel, attribute: .right, multiplier: 1, constant: 0))
        //height
        view.addConstraint(NSLayoutConstraint(item: recipeViewsTextView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0, constant: 20))
    }
    
    func setupMinimizedView() {
        closeButton.frame = CGRect(x: 220, y: 0, width: 30, height: 30)
        closeButton.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        closeButton.setImage(UIImage(named:"add"), for: .normal)
        closeButton.addTarget(mySelf, action: #selector(closeRecipe(_:)), for: .touchUpInside)
        enlargeButton.frame = CGRect(x:220, y:(250*9/16)-30, width: 30, height: 30)
        enlargeButton.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        enlargeButton.setImage(UIImage(named: "add"), for: .normal)
        enlargeButton.addTarget(mySelf, action: #selector(maximizeRecipe(_:)), for: .touchUpInside)
        view?.addSubview(closeButton)
        view?.addSubview(enlargeButton)
        closeButton.isHidden = true
        enlargeButton.isHidden = true
    }
    
    @objc func minimizeRecipe(_ sender: UIButton!){
        if let keyWindow = UIApplication.shared.keyWindow {
            animateView(options: .curveEaseIn, keyWindow: keyWindow)
            closeButton.isHidden = false
            enlargeButton.isHidden = false
        }
    }
    
    @objc func maximizeRecipe(_ sender: UIButton!){
        if minimized! {
            if let keyWindow = UIApplication.shared.keyWindow {
                animateView(options: .curveEaseOut, keyWindow: keyWindow)
                closeButton.isHidden = true
                enlargeButton.isHidden = true
            }
        }
    }
    
    @objc func closeRecipe(_ sender: UIButton!) {
        if minimized! {
            if let keyWindow = UIApplication.shared.keyWindow {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view?.frame =  CGRect(x: keyWindow.frame.width, y: keyWindow.frame.height, width: 0, height: 0)
                }, completion: {(completedAnimation) in
                    self.getIdeasController?.hideStatusBar(hidden: false)
                })
                closeButton.isHidden = false
                enlargeButton.isHidden = false
            }
        }
    }
    
}

