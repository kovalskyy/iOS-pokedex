//
//  ViewController.swift
//  pokedex
//
//  Created by Kacper Kowalski on 17.10.2016.
//  Copyright © 2016 Kacper Kowalski. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var collection: UICollectionView!
    
    var pokemon = [Pokemon]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self          // conform to the protocol
        collection.dataSource = self
       
        parsePokemonCSV()                   //  when it;s called viedidLoad it will do the parsing
    }
    
    func parsePokemonCSV() {                // parsing a CSV file, grab the data from this file and parse it
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
                                                // it can throw error -> so do
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows             // print the rows of csv file
                                            // iterate through the rows and create pokemon objects and put them in a array
            for row in rows {
                let pokeId = Int(row["id"]!)! // row = dictionairy
                let name = row["identifier"]!
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(poke)
            }
            
            
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            // indexPath - index of the row -> grab it and cast as PokeCell!
            
            var poke = pokemon[indexPath.row]
            cell.configureCell(pokemon: poke)
            
            return cell
        } else {
            return UICollectionViewCell()  // return generic one with nothing in it!, if fails of course
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 717
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        return CGSize(width: 105, height: 105)      // size of the grid!
    }
    
    
    
    
    
    
}

