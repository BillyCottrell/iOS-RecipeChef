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
    
    func showRecipe(){
        print("showing recipe launcher")
        
        /*if let keyWindow = UIApplication.shared.keyWindow {
            let view = UIView(frame: keyWindow.frame)
            view.backgroundColor = UIColor.white
            view.frame = CGRect(x: keyWindow.frame.width-10, y: keyWindow.frame.height-10, width: 10, height: 10)
            // 16 x 9 is the most used aspect ratio for videos
            let height = keyWindow.frame.width * 9 / 16
            let imageFrame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            let recipeImageView = RecipeImageView(frame: imageFrame)
            view.addSubview(recipeImageView)
            keyWindow.addSubview(view)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                view.frame = keyWindow.frame
                
            }, completion: { (completedAnimation) in
                //hide statusbar not working
                //UIApplication.shared.setStatusBarHidden(true, with: .fade)
                self.getIdeasController?.hideStatusBar(hidden: true)
            })
        }*/
    }
}
