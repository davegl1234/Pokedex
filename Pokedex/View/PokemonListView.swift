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
    @StateObject var pokemonListViewModel : PokemonListViewModel = PokemonListViewModel()
    //fetch any favourited pokemons from core data
    @FetchRequest(
        entity: PokemonFavourite.entity(),
        sortDescriptors: []
    ) var favourites : FetchedResults<PokemonFavourite>
    var selectedPokemon : SelectedPokemon
    @Binding var pokemonViewOpen : Bool
    let rowWidth : CGFloat
    //passed in filter variables
    @Binding var searchString : String
    @Binding var favouriteFilter : Bool
    var body: some View {
        //Calculate some layout variables here as per list and only need to be done once
        let typeYOffset : CGFloat = (rowHeight / 2) + (((rowHeight / 2) - (rowHeight / 3))/2)
        let imageLength : CGFloat = rowHeight - 7
        if pokemonListViewModel.pokemon.count > 20 {
            List{
                //add dummy row at the top. On load this appears beneath the search bar, but allows the list to scroll underneath the search bar.
                Color.pokadexListColor
                .listRowInsets(EdgeInsets(top: -1, leading: 0, bottom: 0, trailing: 0))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                //if no search prefix entered, use the pokemon list, otherwise filter the pokemon list
                ForEach(pokemonListViewModel.pokemon, id: \.self) { poke in
                    //filter by name, if requested
                    if (filterName(pokemon: poke))
                    {
                        //check if favourited
                        let favourite : PokemonFavourite? = getFavourite(pokemon: poke)
                        if (!favouriteFilter || favourite != nil)
                        {
                            PokemonRow(pokemon: poke, rowWidth: rowWidth, typeYOffset: typeYOffset, imageLength : imageLength, selectedPokemon: selectedPokemon, pokemonViewOpen : $pokemonViewOpen, favourite: favourite, isFavourite : favourite != nil)
                        }
                        
                    }
                    
                }//hide row seperators
                .listRowInsets(EdgeInsets(top: -1, leading: 0, bottom: 0, trailing: 0))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .background(Color.pokadexListColor)
                //options for image caching
                .environment(\.urlImageOptions, URLImageOptions(loadOptions: [ .loadImmediately, .cancelOnDisappear ]))
        
            }
       }
       else {
        //TO-DO initial load when we have retreived less than 20 pokemon, display indiciator
       }
    }

    //if pokemon exists in persistant favourite array, return reference to it. Otherwise nil.
    func getFavourite(pokemon : Pokemon)->PokemonFavourite?
    {
        return favourites.first(where: {$0.name == pokemon.name})
    }
    //return true if pokemon should be displayed.
    func filterName(pokemon : Pokemon)->Bool
    {
        if (searchString != "")
        {
            if (!(pokemon.name.lowercased().hasPrefix(searchString.lowercased())))
            {
                return false
            }
        }
        return true
    }
}
struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader{ geometry in
            PokemonListView(selectedPokemon: SelectedPokemon(), pokemonViewOpen: .constant(false), rowWidth : geometry.size.width, searchString: .constant(""), favouriteFilter: .constant(false))
        }
    }
}

