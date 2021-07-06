//
//  PokemonModel.swift
//  Pokedex
//
//  Created by David Lockwood on 30/06/2021.
//

import Foundation
struct PokemonModel : Codable {
    let name : String
    let height : Int
    let weight : Int
    let sprites : Sprites
    let types : [Types]
    let stats : [Stats]
    
}
struct Sprites : Codable {
    let other: Other
}

struct Types : Codable {
    let type: Type
}

struct Type: Codable {
    let name: String
}

struct Other : Codable {
    let officialArtwork: OfficialArtwork
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct OfficialArtwork: Codable {
    let front_default: String
}

struct Stats: Codable {
    let base_stat: Int
    let stat: Stat
}

struct Stat : Codable {
    let name: String
}
