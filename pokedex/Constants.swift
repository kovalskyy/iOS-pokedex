//
//  Constants.swift
//  pokedex
//
//  Created by Kacper Kowalski on 24.10.2016.
//  Copyright © 2016 Kacper Kowalski. All rights reserved.
//

import Foundation

let URL_BASE = "http://pokeapi.co"
let URL_POKEMON = "/api/v1/pokemon/"

typealias DownloadComplete = () -> ()

// we have to synchronize downloading data from net and view it in viewController 
// we create a closure, block of code that is gonna be called when we want
// custom closure - when download complete somebody can call it and run


