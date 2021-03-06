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
    // used to download images of the recipe when providing the url itself
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
    // used to download images of the recipe when providing the recipe cell
    func downloaded(from link: String,cellgi: RecipeCell? = nil, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, cellgi: cellgi, contentMode: mode)
    }
}

extension UIView {
    //used to shorten the code for adding constraints with visual formats
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
    // this is so the getIdeasController can set those properties without the need of adding/extending the navigationcontroller
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
    //used to easily set rgb values
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UITextView {
    //used to set fontSize
    func setFontSize (size: CGFloat) {
        self.font = UIFont(name: self.font!.fontName, size: size)!
    }
}

extension UILabel {
    func setFontSize (size: CGFloat) {
        self.font = UIFont(name: self.font!.fontName, size: size)!
    }
}
