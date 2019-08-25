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
            // set all the fields about the recipe
            if let recipeImage = recipe?.image {
                recipeImageView.downloaded(from: recipeImage)
            }
            recipeNameLabel.text = recipe!.name
            recipeViewsLabel.text = String(recipe!.views) + " views"
            recipeServingsLabel.text = String(recipe!.servings) + " servings"
            var preparationTimeMin: Int = recipe!.preparationTime
            var preparationTimeHour: Int = 0
            if(preparationTimeMin>=60){
                preparationTimeHour = preparationTimeMin / 60
                preparationTimeMin = preparationTimeMin % 60
                recipePrepTimeLabel.text = String(preparationTimeHour) + (preparationTimeHour==1 ? " hour" : " hours") + (preparationTimeMin==0 ? "" : preparationTimeMin==1 ? " " + String(preparationTimeMin) + " min" :  " " + String(preparationTimeMin) + " mins")
            } else {
                recipePrepTimeLabel.text = String(preparationTimeMin) + (preparationTimeMin==1 ? " min" : " mins")
            }
            recipeDescriptionTextView.text = recipe!.description
            print(recipeDescriptionTextView.text)
        }
    }
    var view: UIView?
    // used for buttons because otherwise self will not be off this class and won't work
    var mySelf: RecipeLauncher?
    
    var backButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 160, y: 100, width: 40, height: 40)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        button.setImage(UIImage(named:"minimize"), for: .normal)
        return button
    }()
    var closeButton = UIButton()
    var enlargeButton = UIButton()
    var recipeImageView: UIImageView = {
        let imageView : UIImageView
        let keyWindow = UIApplication.shared.keyWindow
        // 16 x 9 is the most used aspect ratio for videos
        let imageFrame = CGRect(x: 0, y: 0, width: keyWindow!.frame.width, height: keyWindow!.frame.width * 9 / 16)
        imageView = UIImageView(frame: imageFrame)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    // this is used so the image doesn't become too large
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
    var recipeViewsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //textView.adjustsFontForContentSizeCategory = true
        label.textColor = UIColor.darkGray
        //label.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        return label
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
        let imageView = UIImageView(image: UIImage(named: "prepTime"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    let recipeServingsImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "servings"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    let recipePrepTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        return label
    }()
    let recipeServingsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        return label
    }()
    //these subviews are used to easily center the images and textviews between the 2 separators
    let servingsSubView = UIView()
    let prepTimeSubView = UIView()
    let recipeDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description:"
        label.setFontSize(size: 19)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let recipeDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    let ingredientButton: UIButton = {
        let button = UIButton()
        button.setTitle("Ingredients", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.rgb(red: 193, green: 67, blue: 72)
        return button
    }()
    let preparationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Preparation Method", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.rgb(red: 193, green: 67, blue: 72)
        return button
    }()
    
    // this holds the state of the recipe whether it is minimized or not
    var minimized: Bool?
    
    func showRecipe(){
        //this sets the recipelauncher as "self"
        mySelf = self
        //keywindow is used to make the view as big as the screen of the device
        if let keyWindow = UIApplication.shared.keyWindow {
            view = UIView(frame: keyWindow.frame)
            view?.backgroundColor = UIColor.white
            view?.frame = CGRect(x: keyWindow.frame.width-10, y: keyWindow.frame.height-10, width: 10, height: 10)
            // add all components to the view
            setupView(view: view!, keyWindow: keyWindow)
            //add the view to the keywindow so it is active
            keyWindow.addSubview(view!)
            // animate the view so it takes the full screen
            animateView(options: .curveEaseOut, keyWindow: keyWindow)
        }
    }
    
    func animateView(options: UIView.AnimationOptions, keyWindow: UIWindow) {
        // if options is curveEaseout then the view is opening otherwise it is closing
        let opening = options == UIView.AnimationOptions.curveEaseOut
        // animate the view based on the options
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: options, animations: {
            // set the views frame to full screen or minimized
            self.view?.frame = opening ? keyWindow.frame : CGRect(x: keyWindow.frame.width-255, y: keyWindow.frame.height-(250*9/16)-5, width: 250, height: 250*9/16)
            // shows/hides the backbutton when opened/minimzed
            self.backButton.isHidden = opening ? false : true
            // set the image frame to fullscreen or minimized
            self.recipeImageView.frame = opening ? CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: keyWindow.frame.width * 9 / 16) : CGRect(x: 0, y: 0, width: 250, height: 250*9/16)
            // make sure that the image constraints update
            self.recipeImageView.updateConstraints()
            // set the minimzed property
            self.minimized = opening ? false : true
            // set the sizing view the same as the image so the image isn't larger (just in case it may happen)
            self.recipeImageViewSizingview.frame = opening ? CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: keyWindow.frame.width * 9 / 16) : CGRect(x: 0, y: 0, width: 250, height: 250*9/16)
            // update constraints of subviews and view
            self.servingsSubView.updateConstraints()
            self.prepTimeSubView.updateConstraints()
            self.view?.updateConstraints()
        }, completion: {(completedAnimation) in
            // update the statusbar
            self.getIdeasController?.hideStatusBar(hidden: opening)
        })
    }
    
    func setupView(view:UIView, keyWindow: UIWindow){
        // add targets for buttons
        backButton.addTarget(mySelf, action: #selector(minimizeRecipe(_:)), for: .touchUpInside)
        ingredientButton.addTarget(mySelf, action: #selector(showIngredients(_:)), for: .touchUpInside)
        preparationButton.addTarget(mySelf, action: #selector(showPreparationMethod(_:)), for: .touchUpInside)
        // set the font of the labels and textfiels
        recipeViewsLabel.setFontSize(size: 15)
        recipeServingsLabel.setFontSize(size: 15)
        recipePrepTimeLabel.setFontSize(size: 15)
        recipeDescriptionTextView.setFontSize(size: 17)
        // adds the components for the subview
        servingsSubView.addSubview(recipeServingsImageView)
        servingsSubView.addSubview(recipeServingsLabel)
        prepTimeSubView.addSubview(recipePrepTimeImageView)
        prepTimeSubView.addSubview(recipePrepTimeLabel)
        // this adds all the components to the view
        view.addSubview(recipeImageView)
        view.addSubview(recipeImageViewSizingview)
        view.addSubview(backButton)
        view.addSubview(recipeNameLabel)
        view.addSubview(recipeViewsLabel)
        view.addSubview(separatorView1)
        view.addSubview(prepTimeSubView)
        view.addSubview(servingsSubView)
        view.addSubview(separatorView2)
        view.addSubview(recipeDescriptionTextView)
        view.addSubview(ingredientButton)
        view.addSubview(preparationButton)
        // this setup is for the components of the minimized view
        setupMinimizedView()
        // adds the constraints for the components
        view.addConstraintsWithFormat(format: "H:|-16-[v0(40)]", views: backButton)
        view.addConstraintsWithFormat(format: "V:|-16-[v0(40)]", views: backButton)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: recipeImageView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(==keyview)]-0-[v1(44)]-28-[v2(1)]-8-[v3(48)]-8-[v5(1)]-8-[v6]-[v7(34)]-4-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":recipeImageView, "v1":recipeNameLabel, "keyview":recipeImageViewSizingview, "v2":separatorView1, "v3": prepTimeSubView, "v5": separatorView2, "v6": recipeDescriptionTextView, "v7": ingredientButton]))
        view.addConstraintsWithFormat(format: "V:[v0(1)]-8-[v1(48)]-8-[v2(1)]", views: separatorView1, servingsSubView, separatorView2)
        view.addConstraintsWithFormat(format: "H:|[v0(==v1)]-[v1]|", views: prepTimeSubView, servingsSubView)
        view.addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: recipeNameLabel)
        subTitleConstraints(view: view, keyWindow: keyWindow)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: separatorView1)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: separatorView2)
        //adds the constraints for the subviews
        prepTimeSubView.addConstraintsWithFormat(format: "H:[v0(20)]", views: recipePrepTimeImageView)
        prepTimeSubView.addConstraintsWithFormat(format: "H:|[v0]|", views: recipePrepTimeLabel)
        prepTimeSubView.addConstraint(NSLayoutConstraint(item: recipePrepTimeImageView, attribute: .top, relatedBy: .equal, toItem: prepTimeSubView, attribute: .top, multiplier: 1, constant: 0))
        prepTimeSubView.addConstraint(NSLayoutConstraint(item: recipePrepTimeImageView, attribute: .bottom, relatedBy: .equal, toItem: recipePrepTimeLabel, attribute: .top, multiplier: 1, constant: 0))
        prepTimeSubView.addConstraint(NSLayoutConstraint(item: recipePrepTimeImageView, attribute: .height, relatedBy: .equal, toItem: prepTimeSubView, attribute: .height, multiplier: 0, constant: 20))
        prepTimeSubView.addConstraint(NSLayoutConstraint(item: recipePrepTimeLabel, attribute: .bottom, relatedBy: .equal, toItem: prepTimeSubView, attribute: .bottom, multiplier: 1, constant: 0))
        prepTimeSubView.addConstraint(NSLayoutConstraint(item: recipePrepTimeImageView, attribute: .centerX, relatedBy: .equal, toItem: prepTimeSubView, attribute: .centerX, multiplier: 1, constant: 0))
        servingsSubView.addConstraintsWithFormat(format: "H:[v0(20)]", views: recipeServingsImageView)
        servingsSubView.addConstraintsWithFormat(format: "H:|[v0]|", views: recipeServingsLabel)
        servingsSubView.addConstraint(NSLayoutConstraint(item: recipeServingsImageView, attribute: .top, relatedBy: .equal, toItem: servingsSubView, attribute: .top, multiplier: 1, constant: 0))
        servingsSubView.addConstraint(NSLayoutConstraint(item: recipeServingsImageView, attribute: .bottom, relatedBy: .equal, toItem: recipeServingsLabel, attribute: .top, multiplier: 1, constant: 0))
        servingsSubView.addConstraint(NSLayoutConstraint(item: recipeServingsImageView, attribute: .height, relatedBy: .equal, toItem: servingsSubView, attribute: .height, multiplier: 0, constant: 20))
        servingsSubView.addConstraint(NSLayoutConstraint(item: recipeServingsLabel, attribute: .bottom, relatedBy: .equal, toItem: servingsSubView, attribute: .bottom, multiplier: 1, constant: 0))
        servingsSubView.addConstraint(NSLayoutConstraint(item: recipeServingsImageView, attribute: .centerX, relatedBy: .equal, toItem: servingsSubView, attribute: .centerX, multiplier: 1, constant: 0))
        // adds the bottom 3 components for the view
        view.addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: recipeDescriptionTextView)
        view.addConstraintsWithFormat(format: "H:|-4-[v0(==v1)]-4-[v1]-4-|", views: ingredientButton, preparationButton)
        view.addConstraintsWithFormat(format: "V:[v0]-4-|", views: preparationButton)
    }
    
    func subTitleConstraints(view: UIView, keyWindow: UIWindow) {
        // adds constraints for the subtitle
        view.addConstraint(NSLayoutConstraint(item: recipeViewsLabel, attribute: .top, relatedBy: .equal, toItem: recipeNameLabel, attribute: .bottom, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: recipeViewsLabel, attribute: .left, relatedBy: .equal, toItem: recipeNameLabel, attribute: .left, multiplier: 1, constant: 4))
        view.addConstraint(NSLayoutConstraint(item: recipeViewsLabel, attribute: .right, relatedBy: .equal, toItem: recipeNameLabel, attribute: .right, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: recipeViewsLabel, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0, constant: 20))
    }
    
    func setupMinimizedView() {
        // adds the buttons for the minimized view and
        closeButton.frame = CGRect(x: 220, y: 0, width: 30, height: 30)
        closeButton.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        closeButton.setImage(UIImage(named:"clear"), for: .normal)
        closeButton.addTarget(mySelf, action: #selector(closeRecipe(_:)), for: .touchUpInside)
        enlargeButton.frame = CGRect(x:220, y:(250*9/16)-30, width: 30, height: 30)
        enlargeButton.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        enlargeButton.setImage(UIImage(named: "fullscreen"), for: .normal)
        enlargeButton.addTarget(mySelf, action: #selector(maximizeRecipe(_:)), for: .touchUpInside)
        view?.addSubview(closeButton)
        view?.addSubview(enlargeButton)
        // hides components when minimizing
        closeButton.isHidden = true
        enlargeButton.isHidden = true
        separatorView1.isHidden = false
        separatorView2.isHidden = false
        ingredientButton.isHidden = false
        preparationButton.isHidden = false
        prepTimeSubView.isHidden = false
        servingsSubView.isHidden = false
    }
    
    // func called by button, minimizes recipe
    @objc func minimizeRecipe(_ sender: UIButton!){
        // calls animateView and updates visibility of the components
        if let keyWindow = UIApplication.shared.keyWindow {
            animateView(options: .curveEaseIn, keyWindow: keyWindow)
            closeButton.isHidden = false
            enlargeButton.isHidden = false
            separatorView1.isHidden = true
            separatorView2.isHidden = true
            ingredientButton.isHidden = true
            preparationButton.isHidden = true
            prepTimeSubView.isHidden = true
            servingsSubView.isHidden = true
        }
    }
    
    @objc func maximizeRecipe(_ sender: UIButton!){
        if minimized! {
            if let keyWindow = UIApplication.shared.keyWindow {
                animateView(options: .curveEaseOut, keyWindow: keyWindow)
                closeButton.isHidden = true
                enlargeButton.isHidden = true
                separatorView1.isHidden = false
                separatorView2.isHidden = false
                ingredientButton.isHidden = false
                preparationButton.isHidden = false
                prepTimeSubView.isHidden = false
                servingsSubView.isHidden = false
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
                separatorView1.isHidden = true
                separatorView2.isHidden = true
                ingredientButton.isHidden = true
                preparationButton.isHidden = true
                servingsSubView.isHidden = true
                prepTimeSubView.isHidden = true
            }
        }
    }
    // actives the ingredient launcher
    @objc func showIngredients(_ sender: UIButton!){
        let ingredientLauncher = IngredientLauncher()
        ingredientLauncher.ingredients = recipe?.ingredients
        ingredientLauncher.getIdeasController = getIdeasController
        ingredientLauncher.showIngredients()
    }
    // actives the preparation method launcher
    @objc func showPreparationMethod(_ sender: UIButton!){
        let preparationMethodLauncher = PreparationMethodLauncher()
        preparationMethodLauncher.preparationMethods = recipe?.preparationMethod
        preparationMethodLauncher.getIdeasController = getIdeasController
        preparationMethodLauncher.showPreparationMethods()
    }
    
}
