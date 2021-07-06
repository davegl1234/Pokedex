//
//  PokemonViewModel.swift
//  Pokedex
//
//  Created by David Lockwood on 30/06/2021.
//

import Foundation
import SwiftUI

class PokemonViewModel : ObservableObject {
    
    @Published var name = ""
    @Published var height = ""
    @Published var weight = ""
    @Published var sprite = ""
    @Published var type = ""
    @Published var stats = [Stats]()
    var typeColor : Color = Color.pink
 
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
                        self.height = "0." + String(decoder.height) + "m"
                        self.weight = "0." + String(decoder.weight) + "kg"
                        self.sprite = decoder.sprites.other.officialArtwork.front_default
                        self.type = decoder.types[0].type.name
                        //lookup pokemon type color once, when pokemon parsed out
                        self.typeColor = PokemonViewModel.color(type: self.type)
                        self.stats = decoder.stats
                    }
                }
                catch{
                    //TO DO - error handling
                }
            }
            task.resume()
    }
    //color for each pokemon type
    private class func color(type: String) -> Color {
        switch type {
        case "normal":
            return Color(UIColor.systemBlue)
        case "fighting":
            return Color.orange
        case "flying":
            return Color.blue
        case "poison":
            return Color.green
        case "ground":
            return Color(UIColor.brown)
        case "rock":
            return Color(UIColor.darkGray)
        case "bug":
            return Color(UIColor.systemIndigo)
        case "ghost":
            return Color(UIColor.lightGray)
        case "steel":
            return Color(UIColor.systemGray3)
        case "fire":
            return Color.red
        case "water":
            return Color(UIColor.systemTeal)
        case "grass":
            return Color(UIColor.systemGreen)
        case "electric":
            return Color(UIColor.systemYellow)
        case "psychic":
            return Color.yellow
        case "ice":
            return Color(UIColor.systemTeal)
        case "dragon":
            return Color(UIColor.systemRed)
        case "dark":
            return Color.black
        case "fairy":
            return Color.pink
        case "unknown":
            return Color(UIColor.systemPurple)
        case "shadow":
            return Color.purple
        default:
            return Color.pink
        }
    }
}
