//
//  PokemonNameView.swift
//  Pokedex
//
//  Created by David Lockwood on 03/07/2021.
//

import SwiftUI

struct PokemonNameView: View {
    var pokemon : PokemonViewModel?
    var body: some View {
        if (pokemon != nil)
        {
            Text(pokemon!.name.capitalized(with: .current))
                .foregroundColor(.white)
            
        }
    }
}

struct PokemonNameView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonNameView()
    }
}
