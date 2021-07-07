//
//  PokemonSearchBar.swift
//  Pokedex
//
//  Created by David Lockwood on 06/07/2021.
//

import SwiftUI
import FASwiftUI
struct PokemonSearchBar: View {
    @Binding var searchString : String
    @Binding var favouriteFilter : Bool
    @State var inSearch : Bool = false
    var body: some View {
        ZStack(alignment : .leading){
            //if we aren't typing and there is no current search display search icon (FontAwesome dependancy)
            if (!inSearch && searchString == "")
            {
                FAText(iconName: "Search", size: rowHeight / 2).foregroundColor(Color.purple)
                    .onTapGesture {
                        //if tapped, put into typing mode
                        inSearch = true
                    }.padding(.leading, 8)
                
            }
            HStack{
                //text field to receive input, populates searchString.
                TextField("", text:$searchString, onEditingChanged:
                            //intercept focus changes, flag whether we are in typing mode or not
                { (focus) in
                
                    inSearch = focus
                }
                ).frame(maxWidth : .infinity, maxHeight: rowHeight / 2)
                .foregroundColor(Color.purple)
                .accentColor(Color.purple)
                if (searchString != "")
                {
                    //if we have a search string, present clear button on the right of the search bar.
                    FAText(iconName: "times-circle", size: rowHeight / 2).foregroundColor(Color.purple)
                        .onTapGesture {
                            //if tapped, clear search string
                            searchString = ""
                        }
                        //offset so it sits just inside text field
                        .offset(x : -(rowHeight / 2))
                }
                FAText(iconName: "Star", size: rowHeight / 2, style : favouriteFilter ? .solid : .regular).foregroundColor(Color.gold)
                    .onTapGesture {
                        favouriteFilter.toggle()
                }
                .offset(x : -(rowHeight / 2))
                
            }.frame(maxWidth : .infinity, maxHeight : .infinity)
            .padding(.leading, 8)
            .padding(.trailing, -(rowHeight)/2 + 8)
        }.frame(maxWidth : .infinity, maxHeight : rowHeight / 1.5, alignment : .leading)
        .padding(8)
        .background(
            Color.pokadexBackgroundColor
                //curve background, with a curved border
                .cornerRadius(10, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
                .overlay(RoundedCorner(radius: 10, corners: [.topRight, .topLeft, .bottomLeft, .bottomRight]).stroke(Color.purple, lineWidth: 5))
                .padding(8)
        )
    }
}

struct PokemonSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        PokemonSearchBar(searchString: .constant(""), favouriteFilter: .constant(false))
    }
}

