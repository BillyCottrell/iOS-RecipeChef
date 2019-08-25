//
//  GetIdeasController.swift
//  RecipeChef
//
//  Created by Billy Cottrell on 04/02/2019.
//  Copyright © 2018-2019 Codexive. All rights reserved.
//

import UIKit

// This is the main controller that contains a horizontal collectionView which works as a paging view so you are able to swipe or use the navigation buttons to auto slide to that view
// It also contains the menubar that works with the collectionview when sliding or pressing one of the buttons
class GetIdeasController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // cellid properties of each navigation cell
    var getIdeasCellId = "getIdeasCellId"
    var myRecipesCellId = "myRecipesCellId"
    var leftOverCellId = "leftOverCellId"
    
    // titles of the navigation cells to update on slide or button press
    let titles = ["Get Ideas", "My Recipes", "Use Up Leftovers"]
    
    // menubar that is a collectionView of navigation buttons with a slider
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.getIdeasController = self
        return mb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // makes the nav bar non translucent
        navigationController?.navigationBar.isTranslucent = false
        // create the title of the navbar
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width-32, height: view.frame.height))
        // sets the standard text
        titleLabel.text = "  Get Ideas"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        // sets the titleview of the navigation
        navigationItem.titleView = titleLabel
        // setup the collectionView
        setupCollectionView()
        // calls a setup method that makes the menu bar
        setupMenuBar()
        // setup the search and more buttons
        setupNavBarButtons()
    }
    
    
    func setupCollectionView() {
        // makes the collectionview horizontal instead of vertical
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        // sets the background of the collectionview
        collectionView?.backgroundColor = UIColor.white
        // registers the cell for the collectionview with a certain identifier
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: getIdeasCellId)
        collectionView?.register(MyRecipesCell.self, forCellWithReuseIdentifier: myRecipesCellId)
        collectionView?.register(LeftOverCell.self, forCellWithReuseIdentifier: leftOverCellId)
        //moves the collectionview below the menubar
        collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        //moves the scrollbar below the menubar
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        // gives the paging feeling
        collectionView?.isPagingEnabled = true
    }
    
    func setupNavBarButtons(){
        // this makes the buttons in the upper right corner
        let searchButton = UIBarButtonItem(image: UIImage(named: "search")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleSearch))
        let moreButton = UIBarButtonItem(image: UIImage(named: "more")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMore))
        navigationItem.rightBarButtonItems = [moreButton, searchButton]
    }
    
    @objc func handleSearch(){
        // WIP
    }
    
    @objc func handleMore(){
        //WIP
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        // when menubar button is used scroll to that view and set the title
        let indexPath = NSIndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath as IndexPath, at: [], animated: true)
        setTitleForIndex(index: menuIndex)
    }
    
    func setTitleForIndex(index: Int){
        // sets the title based on the active view
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = "  \(titles[index])"
        }
    }
    
    private func setupMenuBar() {
        // removes the scrollbar on the bottom
        navigationController?.hidesBarsOnSwipe = true
        //this is for when sliding down and top menu hides so no whitespace gets visible
        let redView = UIView()
        redView.backgroundColor = UIColor.rgb(red: 193, green: 67, blue: 72)
        view.addSubview(redView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: redView)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: redView)
        
        // adds the menubar to the view
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: menuBar)
        
        menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // sets menubar scroll when swiping to the next page
        menuBar.horizontalBarViewAnchorContraint?.constant = scrollView.contentOffset.x/3
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // when swiping select the new navigation item
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = NSIndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath as IndexPath, animated: true, scrollPosition: [])
        setTitleForIndex(index: Int(index))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // only 3 navigation items are used atm
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // returns the correct cell based on the index
        let identifier: String
        if indexPath.item == 0{
            identifier = getIdeasCellId
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! FeedCell
            cell.getIdeasController = self
            return cell
        } else if indexPath.item == 1{
            identifier = myRecipesCellId
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! MyRecipesCell
            cell.getIdeasController = self
            return cell
        } else {
            identifier = leftOverCellId
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! LeftOverCell
            cell.getIdeasController = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // sets the height and width to the view (height -50 for menubar)
        return CGSize(width: view.frame.width, height: view.frame.height - 50)
    }
    
    // this updates the status bars visibility
    var statusBarIsHidden: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.5) { () -> Void in
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    // this enables to be used everywhere when it has this controller as a variable to update the statusbar
    func hideStatusBar(hidden: Bool) {
        statusBarIsHidden = hidden
        print("status bar should be hidden")
    }
    // sets the bar style status
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    // sets the statusbar animation
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    // auto updates the status bar based on the property
    override var prefersStatusBarHidden: Bool {
        print(statusBarIsHidden)
        return statusBarIsHidden
    }
    
}
