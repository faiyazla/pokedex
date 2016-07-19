//
//  ViewController.swift
//  Pokedex
//
//  Created by Faiyaz Ahmed on 6/30/16.
//  Copyright © 2016 Faiyaz Ahmed. All rights reserved.
//

import UIKit
import AVFoundation//For music player
class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collection: UICollectionView!
    
    @IBAction func musicButtonPress(sender: UIButton!) {
        if musicPlayer.playing{
            musicPlayer.stop()
            sender.alpha = 0.2
        }
        else{
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done
//        initAudio()
        parsePokemonCSV()
    }
    
//    func initAudio(){
//        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!
//        do {
//            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path)!)
//            musicPlayer.prepareToPlay()
//            musicPlayer.numberOfLoops = -1
//            musicPlayer.play()
//        } catch let err as NSError {
//            print(err.localizedDescription)
//        }
//    }
    
    //parsing the csv file
    func parsePokemonCSV(){
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")
        
        do{
            let csv = try CSV(contentsOfURL: path!)
            let rows = csv.rows
            
            for row in rows{
                let pokeID = Int(row["id"]!)!
                let name = row["identifier"]
                let poke = Pokemon(name: name!, pokedexID: pokeID)
                pokemon.append(poke)
            }
            
        } catch let err as NSError {
            print(err.localizedDescription)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell {
            let poke: Pokemon!
            if inSearchMode {
                poke = filteredPokemon[indexPath.row]
            } else{
                poke = pokemon[indexPath.row]
            }
            cell.configureCell(poke)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }

//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        return 0
//    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredPokemon.count
        }
        else{
            return pokemon.count
        }
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        //size of each column cell
        return CGSizeMake(105, 105)
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)//closing the keyboard after editing
            collection.reloadData()
        }
        else{
            inSearchMode = true
            let lower = searchBar.text!.lowercaseString
            filteredPokemon = pokemon.filter({$0.name.rangeOfString(lower) != nil})
//            //$0 means that its gonna grab element from the array
            collection.reloadData()
        }
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var poke: Pokemon!
        
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
        }else {
            poke = pokemon[indexPath.row]
        }
       performSegueWithIdentifier("PokemonDetailVC", sender: poke)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("right")
        if segue.identifier! == "PokemonDetailVC" {
            if let detailsVC = segue.destinationViewController as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke// passing the value poke to pokemon of pokemondetail
                }
            }
        }
        else {
            print("WRong")
        }
    }
    
}

