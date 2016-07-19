//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Faiyaz Ahmed on 7/1/16.
//  Copyright © 2016 Faiyaz Ahmed. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var mainImg: UIImageView!
    
    @IBOutlet weak var descriptionlbl: UILabel!
    
    @IBOutlet weak var typelLbl: UILabel!
    
    @IBOutlet weak var defenseLbl: UILabel!
    
    @IBOutlet weak var heightLbl: UILabel!
    
    @IBOutlet weak var pokedexLbl: UILabel!
    
    @IBOutlet weak var currentEvoImg: UIImageView!
    
    @IBOutlet weak var nextEvoImg: UIImageView!
    
    @IBOutlet weak var evoLbl: UILabel!
    
    @IBOutlet weak var weightLbl: UILabel!

    @IBOutlet weak var baseAttackLbl: UILabel!
    
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLbl.text = pokemon.name
        let img = UIImage(named: "\(pokemon.pokedexID)")
        mainImg.image = img
        currentEvoImg.image = img
        pokemon.downloadPokemonDetails { () -> () in
            self.updateUI()
    }
}
        func updateUI(){
            descriptionlbl.text = pokemon.description
            typelLbl.text = pokemon.type
            defenseLbl.text = pokemon.defense
            heightLbl.text = pokemon.height
            weightLbl.text = pokemon.weight
            baseAttackLbl.text = pokemon.attack
            pokedexLbl.text = "\(pokemon.pokedexID)"
            if pokemon.nextEvolutionId == "" {
                evoLbl.text = "No Evolutions"
                nextEvoImg.hidden = true
            }else {
                nextEvoImg.hidden = false
                 nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
                var str = "Next Evolution: \(pokemon.nextEvolutionTxt)"
                if pokemon.nextEvolutionLvl != "" {
                 str += " - LVL \(pokemon.nextEvolutionLvl)"
                }
            }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
