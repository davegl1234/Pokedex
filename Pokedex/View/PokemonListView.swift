//
//  PokemonListView.swift
//  Pokedex
//
//  Created by David Lockwood on 30/06/2021.
//

import SwiftUI
import URLImage
import URLImageStore
let listColor : Color = Color(.sRGB, red:0.9, green: 0.9, blue:0.9, opacity: 1.0 )
struct PokemonListView: View {
    @StateObject var pokemonListViewModel = PokemonListViewModel()
    var selectedPokemon : SelectedPokemon
    @Binding var pokemonViewOpen : Bool
    let rowWidth : CGFloat
    var body: some View {
        //Calculate some layout variables here as per list and only need to be done once
        let typeYOffset : CGFloat = (rowHeight / 2) + (((rowHeight / 2) - (rowHeight / 3))/2)
        let imageLength : CGFloat = rowHeight - 7
        if pokemonListViewModel.pokemon.count > 20 {
            List{
                ForEach(pokemonListViewModel.pokemon, id: \.self) { poke in
                    PokemonRow(name: poke.name, rowWidth: rowWidth, typeYOffset: typeYOffset, imageLength : imageLength, selectedPokemon: selectedPokemon, pokemonViewOpen : $pokemonViewOpen)
                }//hide row seperators
                .listRowInsets(EdgeInsets(top: -1, leading: 0, bottom: 0, trailing: 0))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .background(listColor)
                //options for image caching
                .environment(\.urlImageOptions, URLImageOptions(loadOptions: [ .loadImmediately, .cancelOnDisappear ]))
        
            }
       }
       else {
        //TO-DO initial load when we have retreived less than 20 pokemon, display indiciator
       }
    }
}
struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader{ geometry in
            PokemonListView(selectedPokemon: SelectedPokemon(), pokemonViewOpen: .constant(false), rowWidth : geometry.size.width )
        }
    }
}

