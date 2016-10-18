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
   
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self          // conform to the protocol
        collection.dataSource = self
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            // indexPath - index of the row -> grab it and cast as PokeCell!
            
           let pokemon = Pokemon(name: "test", pokedexId: indexPath.row)
            cell.configureCell(pokemon: pokemon)
            
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

