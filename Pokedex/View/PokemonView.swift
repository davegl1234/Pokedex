//
//  PokemonView.swift
//  Pokedex
//
//  Created by David Lockwood on 02/07/2021.
//
import SwiftUI
import URLImage
fileprivate struct RoundedCorner: Shape {

    fileprivate var radius: CGFloat = .infinity
    fileprivate var corners: UIRectCorner = .allCorners

    
    fileprivate func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
    
}

internal extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
let backgroundColor : Color = Color(.sRGB, red:0.6, green: 0.6, blue:0.6, opacity: 0.95)
class SelectedPokemon
{
    var pokemonViewModel : PokemonViewModel? = nil
}
internal struct PokemonViewBlur: UIViewRepresentable {

    internal var effect: UIVisualEffect
    internal func makeUIView(context: Context) -> UIVisualEffectView {
        let effectView = UIVisualEffectView(effect: self.effect)
        
        return effectView
    }
    
    internal func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = self.effect
    }
}
struct PokemonView : View {
    var selectedPokemon : SelectedPokemon
    @Binding var open : Bool
    let screenGeometry : GeometryProxy
    var body: some View {
        //view contains 4 parts - blur at top, view header, view stats, pokmeon icon. Only the header is visible when the pokemon view is closed
        VStack (alignment : .leading, spacing : 0){
            if (open)
            {
                //blur top part of screen when pokemon is open
                PokemonViewBlur(effect: UIBlurEffect(style: .regular))
                    .opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxWidth : .infinity, maxHeight : .infinity)
                    .contentShape(Rectangle())
                    .transition(.opacity)
                    .animation(.linear)
                    //close view when blur tapped
                    .onTapGesture(perform:
                                    {open = false })
                    //using offset and padding to overlay icon image over the pokemon view so need minus padding to extend the blur view
                    .padding(.bottom, -(rowHeight * 2))
                        
            }
            //vstack containing 3 components - header, pokemon icon, and stats
            VStack(alignment: .leading, spacing : 0){
                Button(action: {
                    if (!open)
                    {
                        open = true
                    }
                }){
                    //hstack containing the pokemon header
                    HStack(alignment : .center){
                        //zstack containing the pokemon name and pokemon type. Layout is different when the pokemon view is open or closed
                        ZStack(alignment : .leading){
                            PokemonNameView(pokemon: selectedPokemon.pokemonViewModel)
                                .frame(alignment : .leading)
                            //position type view based on size of pokemon name
                            GeometryReader{geometry in
                                PokemonTypeView(rowWidth: screenGeometry.size.width, pokemon: selectedPokemon.pokemonViewModel).frame(height: typeHeight).offset(x: open ? 0 : geometry.size.width + 10, y: open ? geometry.size.height + 10: 0)
                            }
                        }.fixedSize().offset(x: rowHeight + 10)                   .frame(height: rowHeight, alignment: .center)
                        if (open)
                        {
                            Spacer()
                            HStack{
                                // display height and weight when pokemon view is open
                                VStack(alignment: .trailing){
                                    Text("Height:")
                                    Text("Weight:")
                                }.frame(alignment: .trailing)
                                VStack(alignment: .leading){
                                    Text(selectedPokemon.pokemonViewModel!.height)
                                    Text(selectedPokemon.pokemonViewModel!.weight)
                                }.frame(alignment: .leading)
                            }
                            .frame(height: rowHeight, alignment: .trailing)
                            .padding(.trailing, 10)
                            .foregroundColor(.white).font(.system(size:  screenGeometry.size.width * 0.04))
                        }
                    }
                    .offset(y : open ? rowHeight * 2 : 0)
                     .frame(width : screenGeometry.size.width, height : rowHeight, alignment : .topLeading)
                                   }

                //show icon when the pokemon view is open
                 if (open)
                 {
                      //load sprite using URLImage package
                      URLImage(URL(string:selectedPokemon.pokemonViewModel!.sprite)!) {
                          //displayed before loading
                          EmptyView()
                      } inProgress: { progress in
                          //displayed during loading
                      } failure: { error, retry in
                          //TODO - on failure
                      } content: { image in
                          //when the image has been loaded
                          image
                              .resizable()
                              //clip image as circle, draw  colored overlay border
                              .frame(width: rowHeight * 2, height: rowHeight * 2, alignment:.bottomLeading)
                              .padding(5)
                              .clipShape(Circle())
                              .shadow(radius: 10)
                              .overlay(Circle().stroke(selectedPokemon.pokemonViewModel!.typeColor, lineWidth: 5)).background(listColor)
                      }
                      //also clip the imageView as circle to allow the name bar to pass underneath
                      .clipShape(Circle())
                      .frame(width: rowHeight * 2, height: rowHeight * 2, alignment:
                              .bottomLeading)
                      //offset the icon so its in the center and overlay the blur view and header
                      .offset(x : (screenGeometry.size.width /  2) - rowHeight,  y : -rowHeight / 1.5)
                      
                 }
                //show stats if the pokemon view is open
                if(open)
                {
                    PokemonStatsView(pokemon: selectedPokemon.pokemonViewModel, screenGeometry: screenGeometry)
                         .frame(maxWidth: .infinity, alignment : .topLeading)
                }
            }.frame(alignment : .topLeading)
            .background(
                backgroundColor
                    //offset background when open, so it sits under the icon
                    .offset(y : open ? rowHeight * 2 : 0)
                    .cornerRadius(10, corners: [.topRight, .topLeft])
                    //colored boreder around the background
                    .overlay(RoundedCorner(radius: 10, corners: [.topRight, .topLeft]).stroke(selectedPokemon.pokemonViewModel != nil ? selectedPokemon.pokemonViewModel!.typeColor : .clear, lineWidth: 5).offset(y : open ? rowHeight * 2 : 0) .padding(.bottom, open ? rowHeight * 2 : 0))
                    )
            //add gesture to background to open/close swipe up/down
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                            if (open)
                            {
                                if (value.startLocation.y < value.translation.height)
                                {
                                    open = false
                                }
                            }else if (value.translation.height < value.startLocation.y)
                            {
                                open = true
                            }
                           
                          }
                    )
                
                }
                .frame(width: screenGeometry.size.width, height: screenGeometry.size.height, alignment: .topLeading)
                    .offset(y: selectedPokemon.pokemonViewModel == nil ? screenGeometry.size.height : self.open ? 0 : screenGeometry.size.height - rowHeight)
                   .transition(.move(edge: .bottom))
                   .animation(Animation.spring(response: 0.5, dampingFraction: 0.75, blendDuration: 1))

    }
}
struct PokemonView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader{
            geometry in
            PokemonView(selectedPokemon: SelectedPokemon(), open: .constant(false), screenGeometry: geometry)
        }
    }
}
