//
//  GetIdeasController.swift
//  RecipeChef
//
//  Created by Billy Cottrell on 18/01/2019.
//  Copyright © 2019 Billy Cottrell. All rights reserved.
//

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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
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
