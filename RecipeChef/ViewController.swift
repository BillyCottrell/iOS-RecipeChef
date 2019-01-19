//
//  ViewController.swift
//  RecipeChef
//
//  Created by Billy Cottrell on 04/12/2018.
//  Copyright © 2018 Billy Cottrell. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
/*
class ViewController: UIViewController {
    
    var ref : DatabaseReference!
    var databaseHandle : DatabaseHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseApp.configure()
        /*let ingRecipe = Recept(naam:"Olive Oil", basisIngredient: true, beschrijving: "Olive oil is high on the list of essential cooking aids with its heart-healthy, cholesterol-lowering monounsaturated fats.")*/
        ref = Database.database().reference()
        /*var ingredient : (hoeveelheid_Mass: Measurement<UnitMass>?,hoeveelheid_Volume: Measurement<UnitVolume>?,Recept, vast: Bool)
        ingredient = (Measurement<UnitMass>(value: 1, unit: UnitMass.pounds), nil ,ingRecipe, true)
        var ingredienten : [(hoeveelheid_Mass: Measurement<UnitMass>?,hoeveelheid_Volume: Measurement<UnitVolume>?,Recept, vast: Bool)] = []
        ingredienten.append(ingredient)
        let recept = Recept(naam: "ayered Zucchini Ground Beef Casserole", ingredienten: ingredienten, basisIngredient: false, beschrijving: "When zucchini are in full season this is a great recipe that not only uses it up but it's really delicious. I found this recipe on Diana's kitchen site and have altered it to my own tastes.", aantalPersonen: 6)
        var recipes : [Recept] = []
        recipes.append(ingRecipe)
        recipes.append(recept)
        var newRef = ref.child("recipes").childByAutoId()
        let ingId = newRef.key
        newRef.setValue(["naam":ingRecipe.naam, "basisIngredient":ingRecipe.basisIngredient, "beschrijving":ingRecipe.beschrijving, "aantalPersonen":ingRecipe.aantalPersonen ?? 0])
        newRef = ref.child("recipes").childByAutoId()
        let recId = newRef.key
        newRef.setValue(["naam":recept.naam, "basisIngredient":recept.basisIngredient, "beschrijving":recept.beschrijving, "aantalPersonen": recept.aantalPersonen ?? 0])
        ref.child("recipes").child(recId!).child("ingredienten").setValue(["vast": recept.ingredienten[0]?.vast ??  true, "ingredient":ingId!, "hoeveelheid_Vast":recept.ingredienten[0]?.hoeveelheid_Mass?.value ?? 0,"soort_Vast": recept.ingredienten[0]?.hoeveelheid_Mass?.unit.symbol ?? "", "hoeveelheid_Volume":recept.ingredienten[0]?.hoeveelheid_Volume?.value ?? 0,"soort_Volume": recept.ingredienten[0]?.hoeveelheid_Volume?.unit.symbol ?? "",])
        */
        
        // Do any additional setup after loading the view, typically from a nib.
    }


}

*/
