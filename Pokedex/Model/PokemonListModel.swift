//
//  PokemonListModel.swift
//  Pokedex
//
//  Created by David Lockwood on 30/06/2021.
//

import Foundation
struct PokemonList : Codable{
    let results: [Pokemon]
}

struct Pokemon: Codable,Hashable{
    let name: String
}
