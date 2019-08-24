//
//  Extensions.swift
//  RecipeChef
//
//  Created by Billy Cottrell on 03/08/2019.
//  Copyright © 2018-2019 Codexive. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func downloaded(from url: URL,cellgi: RecipeCell? = nil, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                if cellgi != nil{
                    cellgi?.thumbnailImageView.image = image
                    cellgi?.thumbnailImageView.contentMode = mode
                    cellgi?.setNeedsLayout()
                } else{
                    self.image = image
                    self.contentMode = .scaleAspectFill
                }
                
            }
            }.resume()
    }
    
    func downloaded(from link: String,cellgi: RecipeCell? = nil, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, cellgi: cellgi, contentMode: mode)
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...){
        var viewsDictionary = [String: UIView]()
        for (index,view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
    open override var prefersStatusBarHidden: Bool {
        return topViewController?.prefersStatusBarHidden ?? false
    }
    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return topViewController?.preferredStatusBarUpdateAnimation ?? .none
    }
}

extension UIColor{
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UITextView {
    func setFontSize (size: CGFloat) {
        self.font = UIFont(name: self.font!.fontName, size: size)!
    }
}

extension UILabel {
    func setFontSize (size: CGFloat) {
        self.font = UIFont(name: self.font!.fontName, size: size)!
    }
}

extension RecipeLauncher: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ingredientsTableView{
            let numberOfRows = recipe!.ingredients.count
            print("ing")
            print(numberOfRows)
            return numberOfRows
        } else {
            let numberOfRows = recipe!.preparationMethod.count
            print("prep")
            print(numberOfRows)
            return numberOfRows
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("hi")
        if tableView == ingredientsTableView{
            let cell = ingredientsTableView.dequeueReusableCell(withIdentifier: ingredientCellId, for: indexPath) as! IngredientCell
            print("ingre")
            print(recipe!.ingredients[indexPath.row])
            cell.ingredient = recipe!.ingredients[indexPath.row]
            return cell
        } else {
            let cell = prepMethodsTableView.dequeueReusableCell(withIdentifier: prepMethodCellId, for: indexPath) as! PreparationMethodCell
            print("preparation")
            print(recipe!.preparationMethod[indexPath.row])
            cell.preparationMethod = recipe!.preparationMethod[indexPath.row]
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
