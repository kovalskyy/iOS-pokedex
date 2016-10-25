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
    private var _pokemonUrl: String!
    
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
                
                print(self._weight)
                print(self._height)
                print(self.attack)
                print(self._defense)
                
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
                
                print(self._type)
                
            }

    
            }

        }
    }
}
