//
//  PokemonRow.swift
//  Pokedex
//
//  Created by David Lockwood on 30/06/2021.
//
import SwiftUI
import URLImage
struct PokemonRow: View {
    
    var name: String
    var rowWidth : CGFloat
    var typeYOffset : CGFloat
    var imageLength : CGFloat
    @StateObject var pokemonViewModel = PokemonViewModel()
    var selectedPokemon : SelectedPokemon
    @Binding var pokemonViewOpen : Bool
    var body: some View {
        //if we have pokeman detail
        if pokemonViewModel.sprite != "" {
            Button(action: {
                // select pokemon when row clicked, and open pokemon detail view
                selectedPokemon.pokemonViewModel = pokemonViewModel
                pokemonViewOpen = true
            }) {
                //ZStack filling whole row
                ZStack(alignment:.topLeading){
                    //ZStack colored bar and name, sits underneath sprite
                    ZStack(alignment : .leading){
                        pokemonViewModel.typeColor
                        PokemonNameView(pokemon: pokemonViewModel).padding(.leading, rowHeight / 2 + 5)
                    }
                    //start from middle of sprite, fill rest of row
                    .frame(minWidth : 0, maxWidth: .infinity, minHeight: 0, maxHeight: rowHeight / 2, alignment: .topLeading).padding(.leading, rowHeight / 2)
                    //load sprite using URLImage package
                    URLImage(URL(string:pokemonViewModel.sprite)!) {
                        //displayed before loading
                        EmptyView()
                    } inProgress: { progress in
                        //displayed during loading
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            //match the final image
                            .frame(width: imageLength, height: imageLength, alignment:
                            .center)
                            .padding(5)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(pokemonViewModel.typeColor, lineWidth: 5)).background(listColor)
                    } failure: { error, retry in
                        //TODO - on failure
                        //print("error")
                        EmptyView()
                    } content: { image in
                        //when the image has been loaded
                        image
                            .resizable()
                            //clip image as circle, draw  colored overlay border
                            .frame(width: imageLength, height: imageLength, alignment:.center)
                            .padding(5)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(pokemonViewModel.typeColor, lineWidth: 5)).background(listColor)
                    }
                    //also clip the imageView as circle to allow the name bar to pass underneath
                    .clipShape(Circle())
                    .frame(width: rowHeight, height: rowHeight, alignment:
                    .center)
                    //HStack containing pokemon details
                    HStack{
                        //Colored pokemon type
                        PokemonTypeView(rowWidth: rowWidth, pokemon: pokemonViewModel)
                        //scale type panel to row width
                        .frame(width: rowWidth * (1/6))
                    }//place detail stack based on row height (pre calculated)
                    .frame(minWidth : 0 , maxWidth : .infinity, minHeight : 0 , maxHeight: typeHeight , alignment: .bottomLeading).offset(x: rowHeight + 5, y:typeYOffset)
                }//size of row, width fills entire list
                .frame(maxWidth : .infinity, maxHeight: rowHeight, alignment: .topLeading).padding(5)
            }
        }
        else {
            //need pokemon detail
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .onAppear{
                    //get pokemon detail
                    pokemonViewModel.update(name: name)
                }
                //keep progress row same size of loaded row
                .frame(minWidth : 0, maxWidth : .infinity, minHeight : 0, maxHeight: rowHeight, alignment: .center).padding(5)
        }
        
    }
}

struct PokemonRow_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            let rowHeight : CGFloat = geometry.size.height / 9
            let rowWidth : CGFloat = geometry.size.width
            let typeYOffset : CGFloat = (rowHeight / 2) + (((rowHeight / 2) - (rowHeight / 3))/2)
            let imageLength : CGFloat = rowHeight - 7
            PokemonRow(name: "charmander", rowWidth: rowWidth, typeYOffset: typeYOffset, imageLength : imageLength, selectedPokemon: SelectedPokemon(), pokemonViewOpen: .constant(false))
                .preferredColorScheme(.light)
        }
        
    }
}

