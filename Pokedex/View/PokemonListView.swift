//
//  PokemonListView.swift
//  Pokedex
//
//  Created by David Lockwood on 30/06/2021.
//

import SwiftUI
import URLImage
import URLImageStore
struct PokemonListView: View {
    @StateObject var pokemonListViewModel = PokemonListViewModel()
    let listColor : Color = Color(.sRGB, red:0.9, green: 0.9, blue:0.9, opacity: 1.0 )
    var body: some View {
        //scale row sub-views based on list (device) size. Calculate variables here as per list and only need to be done once
        GeometryReader { geometry in
            let rowHeight : CGFloat = geometry.size.height / 9
            let rowWidth : CGFloat = geometry.size.width
            let typeHeight : CGFloat = rowHeight / 3
            let typeYOffset : CGFloat = (rowHeight / 2) + (((rowHeight / 2) - (rowHeight / 3))/2)
            let imageLength : CGFloat = rowHeight - 7
      
            if pokemonListViewModel.pokemon.count > 20 {
                List{
                    ForEach(pokemonListViewModel.pokemon, id: \.self) { poke in
                        PokemonRow(name: poke.name, rowWidth: rowWidth, rowHeight: rowHeight, typeHeight: typeHeight, typeYOffset: typeYOffset, imageLength : imageLength, listColor : listColor)
                    }//hide row seperators
                    .listRowInsets(EdgeInsets(top: -1, leading: 0, bottom: 0, trailing: 0))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .background(listColor)
                    //options for image caching
                    .environment(\.urlImageOptions, URLImageOptions(loadOptions: [ .loadOnAppear, .cancelOnDisappear ]))
            
                }
           }
           else {
            //TO-DO initial load when we have retreived less than 20 pokemon, display indiciator
           }
        }
    }
}
struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView()
    }
}

