//
//  GetIdeasController.swift
//  RecipeChef
//
//  Created by Billy Cottrell on 04/02/2019.
//  Copyright © 2019 Billy Cottrell. All rights reserved.
//

import UIKit

private let reuseIdentifier = "GetIdeasCell"

class GetIdeasController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var cellId = "cellId"
    var myRecipesCellId = "myRecipesCellId"
    
    let titles = ["Get Ideas", "My Recipes", "Use Up Leftovers"]
    
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
        titleLabel.text = "  Get Ideas"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        // setup the collectionView
        setupCollectionView()
        // calls a setup method that makes the menu bar
        setupMenuBar()
        // setup the search and more buttons
        setupNavBarButtons()
    }
    
    func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        // sets the background of the collectionview
        collectionView?.backgroundColor = UIColor.white
        // registers the cell for the collectionview with a certain identifier
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        
        //moves the collectionview below the menubar
        collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        //moves the scrollbar below the menubar
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        collectionView?.isPagingEnabled = true
    }
    
    func setupNavBarButtons(){
        let searchButton = UIBarButtonItem(image: UIImage(named: "search")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleSearch))
        let moreButton = UIBarButtonItem(image: UIImage(named: "more")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMore))
        navigationItem.rightBarButtonItems = [moreButton, searchButton]
    }
    
    @objc func handleSearch(){
        print(123)
    }
    
    @objc func handleMore(){
        
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = NSIndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath as IndexPath, at: [], animated: true)
        setTitleForIndex(index: menuIndex)
    }
    
    func setTitleForIndex(index: Int){
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = "  \(titles[index])"
        }
    }
    
    private func setupMenuBar() {
        navigationController?.hidesBarsOnSwipe = true
        
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
        menuBar.horizontalBarViewAnchorContraint?.constant = scrollView.contentOffset.x/3
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = NSIndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath as IndexPath, animated: true, scrollPosition: [])
        setTitleForIndex(index: Int(index))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 50)
    }
    
    // sets the bar style status
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
/*
class GetIdeasController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var recipeRef : DatabaseReference!
    var recipeHandle : DatabaseHandle!
    var recipes: [Recipe]!
    
    var selectedRecipe : Recipe?
    
    func fetchRecipes() {
        self.recipes = [Recipe]()
        recipeRef = Database.database().reference(fromURL: Constants.baseurl)
        recipeHandle = recipeRef?.child("recipes").observe(.childAdded, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            guard let name = value?["name"] as? String else {return}
            guard let description = value?["description"] as? String else {return}
            guard let servings = value?["servings"] as? Int else {return}
            var ingredients : [Ingredient] = []
            for ing in value?["ingredients"] as! [NSDictionary] {
                guard let ingredientName = ing["ingredientName"] as? String else {return}
                guard let category = ing["category"] as? String else {return}
                guard let quantity = ing["quantity"] as? String else {return}
                guard let measurement = ing["measurement"] as? String else {return}
                guard let notes = ing["notes"] as? String else {return}
                let ingredient = Ingredient(ingredientName: ingredientName, category: category, quantity: quantity, measurement: measurement, notes: notes)
                ingredients.append(ingredient)
            }
            guard let preparationTime = value?["preparationTime"] as? Int else {return}
            guard let preparationMethod = value?["preparationMethod"] as? [String] else {return}
            guard let image = value?["image"] as? String else {return}
            guard let views = value?["views"] as? Int? else {return}
            guard let id = value?["id"] as? String? else {return}
            let recipe = Recipe(name: name,description: description, servings: servings, ingredients: ingredients, preparationTime: preparationTime, preparationMethod: preparationMethod, image: image, views: views, id: id)
            self.recipes.append(recipe)
            print(self.recipes[0].name)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRecipes()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("Er zijn zoveel recepten in de lijst (dit zijn er normaal meer dan 1):", recipes!.count)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    /*
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }*/


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print(recipes!.count)
        return recipes!.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GetIdeasCell
        let recipe = recipes![indexPath.item]
        print(recipe.name)
        //cell.recipelbl.text = recipe.name
        cell.recipelbl.text = "Hi"
        cell.recipeimg?.downloaded(from: recipe.image)
        // Configure the cell
        //configureCell(cell, forItemAtIndexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        print(indexPath.item)
    }
    
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth, height: screenWidth)
    }
    
    func configureCell(cell: UICollectionViewCell, forItemAtIndexPath: NSIndexPath) {
        //let recipe = recipes[forItemAtIndexPath.index(ofAccessibilityElement: cell)]
        //let imgview:UIImageView
        //imgview?.downloaded(from: recipe.image, cell:cell)
        /*cell.imageView?.downloaded(from: recipe.image, cell: cell)
        //(from: recipe.image, cell: cell)
        cell.setNeedsLayout()
        cell.textLabel?.text = recipe.name*/
    }*/

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}*/

//
//  GetIdeasController.swift
//  RecipeChef
//
//  Created by Billy Cottrell on 18/01/2019.
//  Copyright © 2019 Billy Cottrell. All rights reserved.
//
/*
 import UIKit
 import FirebaseDatabase
 import Firebase
 
 class GetIdeasController: UITableViewController {
 
   var recipeRef : DatabaseReference!
   var recipeHandle : DatabaseHandle!
   var recipes = [Recipe]()
   var selectedRecipe : Recipe?
 
   override func viewDidLoad() {
     super.viewDidLoad()
     // activate firebase
     //fetchRecipes()
     //recipeRef  = Database.database().reference()
     /*recipeHandle = recipeRef.child("recipes").observe(.childAdded, with: { (snapshot) in
       let recipeDict = snapshot.value as? String
       print(recipeDict as Any)
     })*/
     // Uncomment the following line to preserve selection between presentations
     // self.clearsSelectionOnViewWillAppear = false
 
 // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
 // self.navigationItem.rightBarButtonItem = self.editButtonItem
 }
 
 override func viewDidAppear(_ animated: Bool) {
 super.viewDidAppear(animated)
 fetchRecipes()
 }
 
 func fetchRecipes(){
 self.recipes.removeAll()
 recipeRef = Database.database().reference(fromURL: Constants.baseurl)
 recipeHandle = recipeRef?.child("recipes").observe(.childAdded, with: { (snapshot) in
 let value = snapshot.value as? NSDictionary
 guard let name = value?["name"] as? String else {return}
 guard let description = value?["description"] as? String else {return}
 guard let servings = value?["servings"] as? Int else {return}
 var ingredients : [Ingredient] = []
 for ing in value?["ingredients"] as! [NSDictionary] {
 guard let ingredientName = ing["ingredientName"] as? String else {return}
 guard let category = ing["category"] as? String else {return}
 guard let quantity = ing["quantity"] as? String else {return}
 guard let measurement = ing["measurement"] as? String else {return}
 guard let notes = ing["notes"] as? String else {return}
 let ingredient = Ingredient(ingredientName: ingredientName, category: category, quantity: quantity, measurement: measurement, notes: notes)
 ingredients.append(ingredient)
 }
 guard let preparationTime = value?["preparationTime"] as? Int else {return}
 guard let preparationMethod = value?["preparationMethod"] as? [String] else {return}
 guard let image = value?["image"] as? String else {return}
 guard let views = value?["views"] as? Int? else {return}
 guard let id = value?["id"] as? String? else {return}
 
 let recipe = Recipe(name: name,description: description, servings: servings, ingredients: ingredients, preparationTime: preparationTime, preparationMethod: preparationMethod, image: image, views: views, id: id)
 self.recipes.append(recipe)
 self.tableView.reloadData()
 print(self.recipes[0].name)
 })
 }
 
 // MARK: - Table view data source
 
 override func numberOfSections(in tableView: UITableView) -> Int {
 // #warning Incomplete implementation, return the number of sections
 return 1
 }
 
 override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 // #warning Incomplete implementation, return the number of rows
 return recipes.count
 }
 
 
 override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
 
 configure(cell: cell, forItemAt: indexPath)
 //cell.imageView?.setNeedsLayout()
 
 return cell
 }
 
 
 func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {
 let recipe = recipes[indexPath.row]
 cell.imageView?.downloaded(from: recipe.image, cell: cell)
 //(from: recipe.image, cell: cell)
 cell.setNeedsLayout()
 cell.textLabel?.text = recipe.name
 }
 
 /*override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 selectedRecipe = recipes[indexPath.row]
 //prepare(for: , sender: <#T##Any?#>: "RecipeDetailSegue", sender: self)
 //destinationVC.recipe = selectedRecipe
 }*/
 
 /*
 // Override to support conditional editing of the table view.
 override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the specified item to be editable.
 return true
 }
 */
 
 /*
 // Override to support editing the table view.
 override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
 if editingStyle == .delete {
 // Delete the row from the data source
 tableView.deleteRows(at: [indexPath], with: .fade)
 } else if editingStyle == .insert {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */
 
 /*
 // Override to support rearranging the table view.
 override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
 
 }
 */
 
 /*
 // Override to support conditional rearranging of the table view.
 override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the item to be re-orderable.
 return true
 }
 */
 
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 if segue.identifier == "RecipeDetailSegue" {
 let recipeDetailController = segue.destination as! RecipeDetailController
 let index = tableView.indexPathForSelectedRow!.row
 recipeDetailController.recipe = recipes[index]
 }
 }
 
 
 }
 */
