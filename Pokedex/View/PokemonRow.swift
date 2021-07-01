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
    var rowHeight : CGFloat
    var typeHeight : CGFloat
    var typeYOffset : CGFloat
    var imageLength : CGFloat
    let listColor : Color
    
    @StateObject var pokemonViewModel = PokemonViewModel()
    var body: some View {
        //if we have pokeman detail
        if pokemonViewModel.sprite != "" {
            //ZStack filling whole row
            ZStack(alignment:.topLeading){
                //ZStack colored bar and name, sits underneath sprite
                ZStack(alignment : .leading){
                    color(type: pokemonViewModel.type)
                    Text(pokemonViewModel.name.capitalized(with: .current))
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 0, leading: (rowHeight / 2) + 5, bottom: 0, trailing: 0))
                }
                //start from middle of sprite, fill rest of row
                .frame(minWidth : 0, maxWidth: .infinity, minHeight: 0, maxHeight: rowHeight / 2, alignment: .topLeading).padding(EdgeInsets(top: 0, leading: rowHeight / 2, bottom: 0, trailing: 0))
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
                        .overlay(Circle().stroke(color(type: pokemonViewModel.type ), lineWidth: 5)).background(listColor)
                } failure: { error, retry in
                    //TODO - on failure
                } content: { image in
                    //when the image has been loaded
                    image
                        .resizable()
                        //clip image as circle, draw  colored overlay border
                        .frame(width: imageLength, height: imageLength, alignment:.center)
                        .padding(5)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .overlay(Circle().stroke(color(type: pokemonViewModel.type ), lineWidth: 5)).background(listColor)
                }
                //also clip the imageView as circle to allow the name bar to pass underneath
                .clipShape(Circle())
                .frame(width: rowHeight, height: rowHeight, alignment:
                .center)
                //HStack containing pokemon details
                HStack{
                    //ZStack containing colored pokemon type
                    ZStack(alignment: .center){
                        color(type: pokemonViewModel.type )
                        Text(pokemonViewModel.type.capitalized(with: .current))
                            //scale font to row width
                            .foregroundColor(.white).font(.system(size:  rowWidth * 0.04))
                    }
                    //scale type panel to row width
                    .frame(width: rowWidth * (1/6))
                }//place detail stack based on row height (pre calculated)
                .frame(minWidth : 0 , maxWidth : .infinity, minHeight : 0 , maxHeight: typeHeight , alignment: .bottomLeading).offset(x: rowHeight + 5, y:typeYOffset)
            }//size of row, width fills entire list
            .frame(minWidth : 0, maxWidth : .infinity, minHeight : 0, maxHeight: rowHeight, alignment: .topLeading).padding(5)
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
    //color for each pokemon type
    func color(type: String) -> Color {
        switch type {
        case "normal":
            return Color(UIColor.lightGray)
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
            return Color(UIColor.lightText)
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
            return Color.white
        case "shadow":
            return Color.purple
        default:
            return Color.pink
        }
    }
}

struct PokemonRow_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            let rowHeight : CGFloat = geometry.size.height / 9
            let rowWidth : CGFloat = geometry.size.width
            let typeHeight : CGFloat = rowHeight / 3
            let typeYOffset : CGFloat = (rowHeight / 2) + (((rowHeight / 2) - (rowHeight / 3))/2)
            let imageLength : CGFloat = rowHeight - 7
            PokemonRow(name: "charmander", rowWidth: rowWidth, rowHeight: rowHeight, typeHeight: typeHeight, typeYOffset: typeYOffset, imageLength : imageLength, listColor :  Color(.sRGB, red:0.9, green: 0.9, blue:0.9, opacity: 1.0 ))
                .preferredColorScheme(.light)
        }
        
    }
}

