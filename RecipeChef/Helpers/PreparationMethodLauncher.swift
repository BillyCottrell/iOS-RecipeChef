//
//  PreparationMethodLauncher.swift
//  RecipeChef
//
//  Created by Billy Cottrell on 25/08/2019.
//  Copyright © 2019 Billy Cottrell. All rights reserved.
//

import UIKit

class PreparationMethodLauncher: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var preparationMethods: [String]? {
        didSet {
            preparationTable.reloadData()
        }
    }
    var getIdeasController: GetIdeasController?
    var view: UIView?
    var title: UILabel = {
        let label = UILabel()
        label.text = "PreparationMethod"
        label.textColor = .white
        label.backgroundColor = UIColor.rgb(red: 193, green: 67, blue: 72)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 21.0)
        return label
    }()
    lazy var preparationTable: UITableView = {
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
    let preparationCellId = "preparationCellId"
    var mySelf: PreparationMethodLauncher?
    
    func showPreparationMethods(){
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
        view.addSubview(preparationTable)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: preparationTable)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views:preparationTable)
        
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
        preparationTable.tableHeaderView = headerView
        let footerView = UIView()
        footerView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        preparationTable.tableFooterView = footerView
        preparationTable.dataSource = mySelf
        preparationTable.delegate = mySelf
        preparationTable.tableHeaderView?.backgroundColor = UIColor.rgb(red: 193, green: 67, blue: 72)
        preparationTable.translatesAutoresizingMaskIntoConstraints = false
        preparationTable.rowHeight = UITableView.automaticDimension
        preparationTable.estimatedRowHeight = 600
        preparationTable.reloadData()
        preparationTable.register(UITableViewCell.self, forCellReuseIdentifier: preparationCellId)
        
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
        label.text = "Step \(section+1):"
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
        return preparationMethods!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = preparationTable.dequeueReusableCell(withIdentifier: preparationCellId, for: indexPath)
        cell.textLabel?.text = preparationMethods![indexPath.section]
        cell.textLabel?.numberOfLines = 0
        cell.addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: cell.textLabel!)
        cell.addConstraintsWithFormat(format: "V:|[v0]|", views: cell.textLabel!)
        return cell
    }
    
}
