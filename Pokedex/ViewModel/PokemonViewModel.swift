//
//  PokemonViewModel.swift
//  Pokedex
//
//  Created by David Lockwood on 30/06/2021.
//

import Foundation
class PokemonViewModel : ObservableObject {
    
    @Published var name = ""
    @Published var sprite = ""
    @Published var type = ""
    @Published var stats = [Stats]()
 
    let baseURL = "https://pokeapi.co/api/v2/pokemon/"
    func update(name: String) {
        getPokemon(name: name)
    }
    func getPokemon (name: String) {
            let pokemonURL = baseURL+"\(name)/"
            guard let url = URL(string: pokemonURL) else {return}
            let task = URLSession.shared.dataTask(with: url) { (data, resp, err) in
                guard let data = data else {return}
                do {
                    let decoder = try JSONDecoder().decode(PokemonModel.self, from: data)
                    DispatchQueue.main.async {
                        self.name = decoder.name
                        self.sprite = decoder.sprites.other.officialArtwork.front_default
                        self.type = decoder.types[0].type.name
                        self.stats = decoder.stats
                    }
                }
                catch{
                    //TO DO - error handling
                }
            }
            task.resume()
    }
   
}
