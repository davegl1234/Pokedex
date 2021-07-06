//
//  PokemonTypeView.swift
//  Pokedex
//
//  Created by David Lockwood on 03/07/2021.
//

import SwiftUI

struct PokemonTypeView: View {
    var rowWidth : CGFloat
    var pokemon : PokemonViewModel?
    var body: some View {
        //ZStack containing colored pokemon type
        ZStack(alignment: .center){
            if (pokemon != nil)
            {
                pokemon!.typeColor
                Text(pokemon!.type.capitalized(with: .current))
                    //scale font to row width
                    .foregroundColor(.white).font(.system(size:  rowWidth * 0.04))
            }
           
        }
        //scale type panel to row width
        .frame(width: rowWidth * (1/6))
    }
}

struct PokemonTypeView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader{ geometry in
            PokemonTypeView(rowWidth: geometry.size.width)
        }
    }
}
