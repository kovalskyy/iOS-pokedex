//
//  ViewController.swift
//  pokedex
//
//  Created by Kacper Kowalski on 17.10.2016.
//  Copyright © 2016 Kacper Kowalski. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var musicPlayer: AVAudioPlayer!
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var inSearchMode = false
    
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self          // conform to the protocol
        collection.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.enablesReturnKeyAutomatically = false

        
        initAudio()
        parsePokemonCSV()                   //  when it;s called viedidLoad it will do the parsing
        
    }
    
    
    
    
    func initAudio() {
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1      // means infinite loop
            musicPlayer.play()
            
        }   catch let err as NSError {
                print(err.debugDescription)

        }
        

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
            
            let poke: Pokemon!
            
            if inSearchMode {
                poke = filteredPokemon[indexPath.row]
            } else {
                poke = pokemon[indexPath.row]
            }
            
            
            cell.configureCell(pokemon: poke)
            return cell
            
        } else {
            return UICollectionViewCell()  // return generic one with nothing in it!, if fails of course
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let poke: Pokemon!
        
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
        } else {
            poke = pokemon[indexPath.row]
        }
        
        print(poke.name)
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredPokemon.count
        }                               // if we are not in searchmode return the regular number of Pokemon
        
        return pokemon.count
    }
    

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        return CGSize(width: 105, height: 105)      // size of the grid!
    }
    
    
    @IBAction func musicButtonPressed(sender: UIButton!) {
        
        if musicPlayer.isPlaying {
            musicPlayer.stop()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    
    
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)               // close the keyboard
             collection.reloadData()                       // refresh view of data
        } else {
            inSearchMode = true                 // filtering the pokemon 
            let lower = searchBar.text!.lowercased()      // grab the word from textfield, assign lowerCase
                                                    // $0 - grab first object(zero - variable) and grab a name property
                                                    // a range is looking or a string similar to what u typed
                                                    // if it's not nil it will add this name to our filter
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil})
            collection.reloadData()         // refresh and grab current data from data source
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVC = segue.destination as? PokemonDetailVC {
                if let poke = sender as? Pokemon {      // because of perfromsegue!
                    detailsVC.pokemon = poke
                }
            }
        }
    }
    
    
}

