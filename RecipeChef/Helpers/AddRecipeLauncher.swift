//
//  AddRecipeLauncher.swift
//  RecipeChef
//
//  Created by Billy Cottrell on 22/08/2019.
//  Copyright © 2019 Billy Cottrell. All rights reserved.
//

import UIKit

class AddRecipeLauncher: NSObject {
    
    var getIdeasController: GetIdeasController?
    var view: UIView?
    var title: UILabel = {
        let label = UILabel()
        label.text = "Add Recipe (WIP)"
        label.textColor = .white
        label.backgroundColor = UIColor.rgb(red: 193, green: 67, blue: 72)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 21.0)
        return label
    }()
    var backButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 160, y: 100, width: 40, height: 40)
        button.clipsToBounds = true
        button.setImage(UIImage(named:"back"), for: .normal)
        return button
    }()
    var mySelf: AddRecipeLauncher?
    
    func showForm(){
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
        backButton.addTarget(mySelf, action: #selector(minimizeForm(_:)), for: .touchUpInside)
        
        view.addSubview(title)
        view.addSubview(backButton)
        view.addConstraintsWithFormat(format: "H:|[v0]", views: backButton)
        view.addConstraintsWithFormat(format: "V:|[v0]", views: backButton)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: title)
        view.addConstraintsWithFormat(format: "V:|[v0(48)]", views: title)
    }
    
    @objc func minimizeForm(_ sender: UIButton!) {
        if let keyWindow = UIApplication.shared.keyWindow {
            animateView(options: .curveEaseIn, keyWindow: keyWindow)
        }
    }
    
    func animateView(options: UIView.AnimationOptions, keyWindow: UIWindow) {
        let opening = options == UIView.AnimationOptions.curveEaseOut
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: options, animations: {
            self.view!.frame = opening ? keyWindow.frame :  CGRect(x: keyWindow.frame.width, y: 0, width: 0, height: keyWindow.frame.height)
        }, completion: {(completedAnimation) in
            self.getIdeasController?.hideStatusBar(hidden: opening)
        })
    }
}
