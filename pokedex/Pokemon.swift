//
//  Pokemon.swift
//  pokedex
//
//  Created by Kacper Kowalski on 17.10.2016.
//  Copyright © 2016 Kacper Kowalski. All rights reserved.
//

import Foundation
import Alamofire


class Pokemon {
    private var _name: String
    private var _pokedexId: Int // you cant even create a pokemon, when u dont pass name & id
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    private var _pokemonUrl: String!
    
    var description: String {            // prevent from CRASHES!!!
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
         return _defense
    }
    
    var height: String {
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
    
    var attackk: String {
        if attack == nil {
            attack = ""
        }
        return attack
    }
    
    var nextEvoTxt: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    var nextEvoId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
     }
   
    var nextEvoLvl: String {
        if _nextEvolutionLvl == nil {
            _nextEvolutionLvl = ""
        }
        return _nextEvolutionLvl
    }
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    
    init(name: String, pokedexId: Int) { // PASS that Data in !
        self._name = name
        self._pokedexId = pokedexId
   
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
        
    }
    
    func downloadPokemonDetails(_completed: @escaping DownloadComplete) {
        
       Alamofire.request(_pokemonUrl).responseJSON { response in
           debugPrint(response)
        if let json = response.result.value {
           print("JSON: \(json)")

            
            if let dict = response.result.value as? [String: AnyObject] { // grabbing dictionairy from JSON

                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {         // assigning var from dict to proper pokemon object (our var)
                    self.attack = "\(attack)"               // converting into a string
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
               // print(self._weight)
               // print(self._height)
               // print(self.attack)
               // print(self._defense)
                
                if let types = dict["types"] as?  [Dictionary<String, String>] , types.count > 0  {     // an array of dictionairies
                    if let name = types[0]["name"] {        // calling a dictionairy and grabing name property from it
                        self._type = name.capitalized
                    }
                    if types.count > 1 {
                        for x in 1 ..< types.count {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalized)"
                                
                            }
                        }
                    }
      
                } else {
                    self._type = ""
                    
                }
                
               // print(self._type)
                
                // Descriptions
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] , descArr.count > 0 {
                    if let url = descArr[0]["resource_uri"] {
                        let descURL = "\(URL_BASE)\(url)"
                        
                        Alamofire.request(descURL).responseJSON(completionHandler: { response in
                            
                            if let descDict = response.result.value as? [String: AnyObject] {
                                
                                if let description = descDict["description"] as? String {
                                 let newDesc = description.replacingOccurrences(of: "POKMON", with: "Pokemon") // some bug in API data!
                                    self._description = newDesc
                                   // print(self._description)
                                }
                            }
                            
                            _completed()
                        })
                    }
                
                } else {
                    self._description = ""
                    _completed()
                }
                // Evolutions
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] , evolutions.count > 0 {
                    
                    if let to = evolutions[0]["to"] as? String {                       // "to" is a name of nextEVo
                        
                        if to.range(of: "mega") == nil {            // Cant support mega pokemon right now
                            
                                                                    // extract pokemonId from the uri
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                
                                let newStr = uri.replacingOccurrences(of: "api/v1/pokemon", with: "") // getting rid of "of" and place with empty Str
                                let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvolutionId = nextEvoId
                                self._nextEvolutionTxt = to
                                
                                if let lvl = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLvl = "\(lvl)"       // convert to a string
                                }
                               // print(self._nextEvolutionId)
                               // print(self._nextEvolutionTxt)
                               // print(self._nextEvolutionLvl)
                                
                            } else {
                                self._nextEvolutionLvl = ""
                            }
                        }
                    
                    }
                    
                }
                
            }
    
            }

        }
    }
}
