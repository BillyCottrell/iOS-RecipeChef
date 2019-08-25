//
//  LeftOverCell.swift
//  RecipeChef
//
//  Created by Billy Cottrell on 25/08/2019.
//  Copyright © 2019 Billy Cottrell. All rights reserved.
//

import UIKit

class LeftOverCell: BaseCollectionViewCell , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellId = "leftOverCellId"
    
    var getIdeasController: GetIdeasController?
    
    var wip: UILabel = {
        let label = UILabel()
        label.text = "Left Over (WIP)"
        label.textColor = .white
        label.backgroundColor = UIColor.rgb(red: 193, green: 67, blue: 72)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 21.0)
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        collectionView.register(MyRecipesMenuCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // returns the cell based on the index
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        let keyWindow = UIApplication.shared.keyWindow
        let view = UIView(frame: keyWindow!.frame)
        view.addSubview(wip)
        wip.center = view.center
        cell.addSubview(view)
        return cell
    }
}
