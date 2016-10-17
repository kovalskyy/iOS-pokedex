//
//  Pokemon.swift
//  pokedex
//
//  Created by Kacper Kowalski on 17.10.2016.
//  Copyright © 2016 Kacper Kowalski. All rights reserved.
//

import Foundation


class Pokemon {
    private var _name: String!
    private var _pokedexId: Int! // you cant even create a pokemon, when u dont pass name & id
    
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int) { // PASS that Data in ! 
        self._name = name
        self._pokedexId = pokedexId
    }
    
    
    
}
