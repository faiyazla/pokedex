//
//  Pokemon.swift
//  Pokedex
//
//  Created by Faiyaz Ahmed on 6/30/16.
//  Copyright © 2016 Faiyaz Ahmed. All rights reserved.
//

import Foundation
import UIKit


class Pokemon {
    private var _name: String!
    private var _pokedexID: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _pokemonUrl: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    
    
        var name: String{
        return _name
    }
    var description: String{
        if _description == nil {
            _description = ""
        }
        return _description
    }
    var type: String{
        if _type == nil {
        _type = ""
        }
        return _type
    }
    var defense: String{
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    var height: String{
        if _height == nil {
            _height = ""
        }
        return _height
    }
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    var pokedexID: Int{
        return _pokedexID
    }
    var nextEvolutionTxt: String{
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    var nextEvolutionLvl: String {
        get {
            if _nextEvolutionLvl == nil {
                _nextEvolutionLvl = ""
            }
            return _nextEvolutionLvl
        }
    }
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    init(name: String, pokedexID: Int){
        self._name = name
        self._pokedexID = pokedexID
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexID)/"
        //print("\(URL_BASE)\(URL_POKEMON)\(self._pokedexID)")
    }
    func downloadPokemonDetails(completed: DownloadComplete){
        let url = NSURL(string: _pokemonUrl)!
        print(url)
       
       //setting an afhttp connection since alamofire is not able to bypass captcha to display the json
        let manager = AFHTTPSessionManager()
        manager.GET(_pokemonUrl, parameters: nil, progress: { (NSProgress) in

            }, success: { (task, resObj) in
                //resObj stores the json response resObj = response object
                if let dict = resObj as? Dictionary<String, AnyObject>{
                    if let weight = dict["weight"] as? String{
                        self._weight = weight
                        print(self._weight)
                    }
                    if let height = dict["height"] as? String{
                        self._height = height
                        print(self._height)
                    }
                    if let attack = dict["attack"] as? Int {
                        self._attack = "\(attack)"
                    }
                    if let defense = dict["defense"] as? Int {
                        self._defense = "\(defense)"
                        print(self._defense)
                    }
                    if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0{
                        if let name = types[0]["name"] {
                           self._type = name
                        }
                        if types.count > 1 {
                            for var x = 1; x < types.count; x+=1 {
                                if let name = types[x]["name"] {
                                    self._type! += "/\(name.capitalizedString)"
                                }
                            }
                        }
                    }
                    else {
                        self._type = ""
                    }
                    print(self._type)
                    if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0 {
                        if let url = descArr[0]["resource_uri"]{
                            let url2 = "\(URL_BASE)\(url)"
                            print(url2)
                            let manage = AFHTTPSessionManager()
                            manage.GET(url2, parameters: nil, progress: { (NSProgress) in
                                
                                }, success: { (task, resObj) in
                                    if let desDict = resObj as? Dictionary<String, AnyObject> {
                                        if let description = desDict["description"] as? String {
                                            self._description = description
                                            print(self._description)
                                        }
                                    }
                                    completed()
                                }, failure: { (task, error) in
                                    print("error: \(error)")
                            })
                        }else {
                            self._description = ""
                        }
                        if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                            if let to = evolutions[0]["to"] as? String {
                               //cant support mega pokemon right now. But, api still has mega data
                                if to.rangeOfString("mega") == nil {
                                    if let uri = evolutions[0]["resource_uri"] as? String{
                                        let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                        let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                        self._nextEvolutionId = num
                                        self._nextEvolutionTxt = to
                                        
                                        if let lvl = evolutions[0]["level"] as? Int {
                                            self._nextEvolutionLvl = "\(lvl)"
                                        }
                                    }
                                }
                            }
                        }
                        }
                }//termination of the json url loaded data via AFNETWORKING
            }) { (task, error) in
                print("error: \(error)")
        }//checks if the response was accepted or failed
        
        }
}