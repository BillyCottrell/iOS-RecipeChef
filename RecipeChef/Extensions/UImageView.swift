//
//  UImageView.swift
//  RecipeChef
//
//  Created by Billy Cottrell on 19/01/2019.
//  Copyright © 2019 Billy Cottrell. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func downloaded(from url: URL,cell: UITableViewCell? = nil, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                if cell != nil{
                    cell?.imageView?.image = image
                    cell?.imageView?.contentMode = mode
                    cell?.setNeedsLayout()
                } else{
                    self.image = image
                    self.contentMode = .scaleAspectFill
                }
                
            }
        }.resume()
    }
    func downloaded(from link: String,cell: UITableViewCell? = nil, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url,cell: cell, contentMode: mode)
    }
}
