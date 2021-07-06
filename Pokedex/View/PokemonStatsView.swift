//
//  PokemonStatsView.swift
//  Pokedex
//
//  Created by David Lockwood on 05/07/2021.
//

import SwiftUI
struct PokemonStatsView: View {
    let pokemon: PokemonViewModel?
    let screenGeometry : GeometryProxy
    var body: some View {
        VStack(alignment : .leading) {
             if (pokemon != nil)
             {
                 ForEach(0 ..< pokemon!.stats.count)
                 {
                    //loop through each stat and create capsule view
                    let statName = pokemon!.stats[$0].stat.name.capitalized
                    PokemonStatView(screenGeometry: screenGeometry, value: pokemon!.stats[$0].base_stat, stat: statName, color: statColor(name: statName))
                     
                 }
             }
        }.padding()
    }
    //color stat bar based on type
    func statColor(name: String) -> Color
    {
        switch (name)
        {
        case "Hp":
            return Color.green
        case "Attack":
            return Color.red
        case "Special-Attack":
            return Color(UIColor.red)
        case "Defense":
            return Color.purple
        case "Special-Defense":
            return Color(UIColor.purple)
        case "Speed":
            return Color.yellow
        default:
            return Color.blue
        }
    }
}
struct PokemonStatView: View {
    var screenGeometry : GeometryProxy
    var value: Int
    var stat: String
    var color: Color
    //relative size of stat/value/capsule
    var sizeStat : CGFloat = 0.4
    var sizeValue : CGFloat = 0.1
    //absolute stat capsule frame. Used to animate value.
    @State var capsuleFrame : CGFloat = 0
    var body: some View {
        HStack(alignment : .top){
            //stat name
            Text(stat)
                .padding(.leading, 2)
                .foregroundColor(.white)
                //scale by device width
                .frame(width: screenGeometry.size.width * sizeStat,  alignment: .leading)
            //stat value
            HStack {
                Text("\(value)")
                    //scale by device width
                    .frame(width: screenGeometry.size.width * sizeValue)
                    .padding(.trailing)
                    .foregroundColor(.white)
                //two capsules to depict stat value amount
                ZStack(alignment: .leading) {
                    //grey stat outline
                    Capsule()
                        .frame(maxWidth: .infinity, maxHeight: 20)
                        .animation(Animation.spring(response: 1.0, dampingFraction: 0.5, blendDuration: 2).speed(2))
                        .transition(.slide)
                        .foregroundColor(Color(.systemGray5))
                    //colored stat value, based on available space
                    GeometryReader{ geometry in
                        Capsule()
                            .frame(width: capsuleFrame, height : 20)
                            .onAppear(perform: {
                                //animate from zero to stat value, scaled by row width
                                let scaled = screenGeometry.size.width * 0.002 * CGFloat(value)
                                capsuleFrame = scaled > geometry.size.width ? geometry.size.width : scaled})
                            .animation(Animation.spring(response: 1.0, dampingFraction: 0.5, blendDuration: 2).speed(2))
                            .transition(.slide)
                            .foregroundColor(color)
                    }
                }
                Spacer()
            }.padding(.leading)
        }
    }
}
struct PokemonStatsView_Preview: PreviewProvider {
    static var previews: some View {
        GeometryReader{ geometry in
            PokemonStatsView(pokemon: nil, screenGeometry: geometry)
        }
    }
}

