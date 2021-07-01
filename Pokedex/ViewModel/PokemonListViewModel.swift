//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by David Lockwood on 30/06/2021.
//

import Foundation
class PokemonListViewModel : ObservableObject {
    
    let baseURL = "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=200"
    
    @Published var pokemon = [Pokemon]()
    
    
    
    init() {
        getPokemonList()
    }
    func getPokemonList() {
        
        let apiURL = URL(string: baseURL)!
        
        let task = URLSession.shared.dataTask(with: apiURL) { (data, resp, err) in
            guard let data = data else {return}
            
            do {
                
                let decoder = try JSONDecoder().decode(PokemonList.self, from: data)
                DispatchQueue.main.async {
                    self.pokemon = decoder.results
            
                }
            }
            
            catch {
                //TO DO - error handling
            }
        }
        task.resume()
    }
}
