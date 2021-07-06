//
//  ContentView.swift
//  Pokedex
//
//  Created by David Lockwood on 28/06/2021.
//

import SwiftUI
import CoreData

let rowHeight : CGFloat = 61
var typeHeight : CGFloat = rowHeight / 3
struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    //selected pokemon class containing pointer to pokemonViewModel. Passed into list view and row (updated when a row is clicked) and into pokemon view for when the pokemon view is opened
    var selectedPokemon : SelectedPokemon = SelectedPokemon()
    //state which controls whether the pokemon view is opened or closed. Passed into list view so updated when row is clicked and into pokemon view itself
    @State var pokemonViewOpen : Bool = false
    //pokemon list filtered by following name prefix. It is passed into the search bar and the pokemon list.
    @State var searchString : String = ""
    
    var body: some View {
        ZStack
        {
            GeometryReader { geometry in
                //list of pokemon
                PokemonListView(selectedPokemon: selectedPokemon, pokemonViewOpen: $pokemonViewOpen, rowWidth: geometry.size.width, searchString: $searchString)
                //search bar for filtering pokemon by prefix
                PokemonSearchBar(searchString: $searchString)
                //pokemon detail view
                PokemonView(selectedPokemon: selectedPokemon, open: $pokemonViewOpen, screenGeometry: geometry)
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
