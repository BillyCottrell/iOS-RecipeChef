//
//  RecipeLauncher.swift
//  RecipeChef
//
//  Created by Billy Cottrell on 12/08/2019.
//  Copyright © 2018-2019 Codexive. All rights reserved.
//

import UIKit

class RecipeLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
    /*lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: UIScreen.main.bounds)
        view.backgroundColor = .red
        let keyWindow = UIApplication.shared.keyWindow
        view.contentSize = CGSize(width: keyWindow!.bounds.width, height: keyWindow!.bounds.height * 2)
        print(view.contentSize.height)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()*/
    var scrollView: UIScrollView?
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
    lazy var ingredientsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .blue
        cv.dataSource = self
        cv.delegate = self
        cv.isScrollEnabled = false
        return cv
    }()
    lazy var prepMethodsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .red
        cv.dataSource = self
        cv.delegate = self
        cv.isScrollEnabled = false
        return cv
    }()
    let ingredientCellId = "ingredientCellId"
    let prepMethodCellId = "prepMethodCellId"
    var minimized: Bool?
    
    func showRecipe(){
        mySelf = self
        print("showing recipe launcher")
        if let keyWindow = UIApplication.shared.keyWindow {
            scrollView = UIScrollView(frame: UIScreen.main.bounds)
            view = UIView()
            scrollView?.backgroundColor = .red
            scrollView?.contentSize = CGSize(width: keyWindow.bounds.width, height: keyWindow.bounds.height * 2)
            print(scrollView!.contentSize.height)
            scrollView?.translatesAutoresizingMaskIntoConstraints = false
            view?.translatesAutoresizingMaskIntoConstraints = false
            //let bounds = UIScreen.main.bounds.size
            keyWindow.addSubview(scrollView!)
            scrollView?.addSubview(view!)
            view?.frame = CGRect(x: keyWindow.frame.width-10, y: keyWindow.frame.height-10, width: 10, height: 10)
            scrollView?.frame = CGRect(x: keyWindow.frame.width-10, y: keyWindow.frame.height-10, width: 10, height: 10)
            //scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
            //scrollView?.backgroundColor = UIColor.white
            //view = UIView(frame: scrollView.frame)
            view?.backgroundColor = UIColor.white
            setupView(view: view!, keyWindow: keyWindow)
            keyWindow.addConstraintsWithFormat(format: "H:|[v0]|", views: scrollView!)
            keyWindow.addConstraintsWithFormat(format: "V:|[v0]|", views: scrollView!)
            scrollView?.widthAnchor.constraint(equalTo: keyWindow.widthAnchor).isActive = true
            scrollView?.heightAnchor.constraint(equalTo: keyWindow.heightAnchor).isActive = true
            scrollView?.addConstraintsWithFormat(format: "H:|[v0]|", views: view!)
            scrollView?.addConstraintsWithFormat(format: "V:|[v0]|", views: view!)
            view?.widthAnchor.constraint(equalTo: keyWindow.widthAnchor).isActive = true
            view?.heightAnchor.constraint(equalTo: keyWindow.heightAnchor).isActive = true
            /*scrollView.leftAnchor.constraint(equalTo: keyWindow.leftAnchor).isActive = true
            scrollView.topAnchor.constraint(equalTo: keyWindow.topAnchor).isActive = true
            view.leftAnchor.constraint(equalTo: keyWindow.leftAnchor).isActive = true
            view.topAnchor.constraint(equalTo: keyWindow.topAnchor).isActive = true*/
            //view.frame = CGRect(x: keyWindow.frame.width-10, y: keyWindow.frame.height-10, width: 10, height: 10)
            //scrollView.frame = CGRect(x: keyWindow.frame.width-10, y: keyWindow.frame.height-10, width: 10, height: 10)
            
            //scrollView.addConstraintsWithFormat(format: "H:|[v0]|", views: view!)
            //scrollView.addConstraintsWithFormat(format: "V:|[v0]|", views: view!)
            //scrollView.addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: scrollView, attribute: .height, multiplier: 1, constant: 0))
            //scrollView.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0))
            animateView(options: .curveEaseOut, keyWindow: keyWindow)
        }
    }
    
    func animateView(options: UIView.AnimationOptions, keyWindow: UIWindow) {
        let opening = options == UIView.AnimationOptions.curveEaseOut
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: options, animations: {
            self.scrollView?.widthAnchor.constraint(equalTo: keyWindow.widthAnchor).isActive = opening
            self.scrollView?.heightAnchor.constraint(equalTo: keyWindow.heightAnchor).isActive = opening
            self.view?.widthAnchor.constraint(equalTo: keyWindow.widthAnchor).isActive = opening
            self.view?.heightAnchor.constraint(equalTo: keyWindow.heightAnchor).isActive = opening
            self.scrollView?.frame = opening ? keyWindow.frame : CGRect(x: keyWindow.frame.width-255, y: keyWindow.frame.height-(250*9/16)-5, width: 250, height: 250*9/16)
            self.scrollView?.contentSize = opening ? CGSize(width: keyWindow.frame.width, height: keyWindow.frame.height) : CGSize(width: 250, height: 250*9/16)
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
        view.addSubview(ingredientsCollectionView)
        view.addSubview(prepMethodsCollectionView)
        setupMinimizedView()
        view.addConstraintsWithFormat(format: "H:|-16-[v0(40)]", views: backButton)
        view.addConstraintsWithFormat(format: "V:|-16-[v0(40)]", views: backButton)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: recipeImageView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(==keyview)]-0-[v1(44)]-28-[v2(1)]-8-[v3(48)]-8-[v5(1)]-8-[v6]-8-[v7]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":recipeImageView, "v1":recipeNameLabel, "keyview":recipeImageViewSizingview, "v2":separatorView1, "v3": prepTimeSubView, "v5": separatorView2, "v6": ingredientsCollectionView, "v7": prepMethodsCollectionView]))
        view.addConstraintsWithFormat(format: "V:[v0(1)]-8-[v1(48)]-8-[v2(1)]", views: separatorView1, servingsSubView, separatorView2)
        view.addConstraintsWithFormat(format: "H:|[v0(==v1)]-[v1]|", views: prepTimeSubView, servingsSubView)
        view.addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: recipeNameLabel)
        subTitleConstraints(view: view, keyWindow: keyWindow)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: separatorView1)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: separatorView2)
        
        prepTimeSubView.addConstraintsWithFormat(format: "H:[v0(20)]", views: recipePrepTimeImageView)
        prepTimeSubView.addConstraintsWithFormat(format: "H:|[v0]|", views: recipePrepTimeTextView)
        prepTimeSubView.addConstraintsWithFormat(format: "V:|[v0(20)]-[v1]|", views: recipePrepTimeImageView, recipePrepTimeTextView)
        //recipePrepTimeImageView.center = prepTimeSubView.center
        //recipeServingsImageView.center = servingsSubView.center
        //prepTimeSubView.addConstraint(NSLayoutConstraint(item: recipePrepTimeImageView, attribute: .centerY, relatedBy: .equal, toItem: prepTimeSubView, attribute: .centerY, multiplier: 1, constant: 0))
        prepTimeSubView.addConstraint(NSLayoutConstraint(item: recipePrepTimeImageView, attribute: .centerX, relatedBy: .equal, toItem: prepTimeSubView, attribute: .centerX, multiplier: 1, constant: 0))
        servingsSubView.addConstraintsWithFormat(format: "H:[v0(20)]", views: recipeServingsImageView)
        servingsSubView.addConstraintsWithFormat(format: "H:|[v0]|", views: recipeServingsTextView)
        servingsSubView.addConstraintsWithFormat(format: "V:|[v0(20)]-[v1]|", views: recipeServingsImageView, recipeServingsTextView)
        //servingsSubView.addConstraint(NSLayoutConstraint(item: recipeServingsImageView, attribute: .centerY, relatedBy: .equal, toItem: servingsSubView, attribute: .centerY, multiplier: 1, constant: 0))
        servingsSubView.addConstraint(NSLayoutConstraint(item: recipeServingsImageView, attribute: .centerX, relatedBy: .equal, toItem: servingsSubView, attribute: .centerX, multiplier: 1, constant: 0))
        //view.addConstraintsWithFormat(format: "H:[v0(20)]-[v1(20)]", views: recipePrepTimeImageView, recipeServingsImageView)
        //view.addConstraintsWithFormat(format: "H:|[v0(==v1)]-[v1(==v0)]|", views: recipePrepTimeTextView, recipeServingsTextView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: ingredientsCollectionView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: prepMethodsCollectionView)
        ingredientsCollectionView.reloadData()
        prepMethodsCollectionView.reloadData()
        ingredientsCollectionView.register(IngredientCell.self, forCellWithReuseIdentifier: ingredientCellId)
        prepMethodsCollectionView.register(PreparationMethodCell.self, forCellWithReuseIdentifier: prepMethodCellId)
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
                    self.scrollView?.frame =  CGRect(x: keyWindow.frame.width, y: keyWindow.frame.height, width: 0, height: 0)
                }, completion: {(completedAnimation) in
                    self.getIdeasController?.hideStatusBar(hidden: false)
                })
                closeButton.isHidden = false
                enlargeButton.isHidden = false
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == ingredientsCollectionView {
            return recipe!.ingredients.count
        } else {
            return recipe!.preparationMethod.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == ingredientsCollectionView {
            let cell = ingredientsCollectionView.dequeueReusableCell(withReuseIdentifier: ingredientCellId, for: indexPath) as! IngredientCell
            cell.ingredient = recipe!.ingredients[indexPath.item]
            return cell
        } else {
            let cell = prepMethodsCollectionView.dequeueReusableCell(withReuseIdentifier: prepMethodCellId, for: indexPath) as! PreparationMethodCell
            cell.preparationMethod = recipe!.preparationMethod[indexPath.item]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // returns the size of a cell
        let keyWindow = UIApplication.shared.keyWindow
        
        return CGSize.init(width: keyWindow!.frame.width-16, height: 44)
    }
    
}

