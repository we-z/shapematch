//
//  AnimationsView.swift
//  shapematch
//
//  Created by Wheezy Capowdis on 8/18/24.
//

import SwiftUI
import Vortex

struct AnimationsView: View {
    var body: some View {
        NoMoreSwipesView()
    }
}

#Preview {
    AnimationsView()
}

struct NoMoreSwipesView: View {
    var body: some View {
        VStack{
            Text("✋")
                .font(.system(size: deviceWidth/3))
                .customTextStroke(width: 4)
                .padding(.bottom, 0)
            Text("NO MORE SWIPES!")
                .italic()
                .bold()
                .font(.system(size: deviceWidth/15))
                .customTextStroke(width: 1.5)
            Button {
                
            } label: {
                HStack{
                    Spacer()
                    Text("Use 1 Live 💙")
                        .bold()
                        .font(.system(size: deviceWidth/15))
                        .customTextStroke(width: 1.5)
                    Spacer()
                }
                .padding()
                .background(.blue)
                .cornerRadius(15)
                .overlay{
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.black, lineWidth: 4)
                        .padding(1)
                }
                .padding(.horizontal)
            }
            .buttonStyle(.roundedAndShadow6)
            Button {
                
            } label: {
                Text("Try again 🔁")
                    .bold()
                    .font(.system(size: deviceWidth/15))
                    .customTextStroke(width: 1.5)
                    .padding()
                    .background(.green)
                    .cornerRadius(15)
                    .overlay{
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black, lineWidth: 4)
                            .padding(1)
                    }
                    .padding()
            }
            .buttonStyle(.roundedAndShadow6)
        }
        .padding()
        .background(.red)
        .cornerRadius(30)
        .overlay{
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.black, lineWidth: 7)
                .padding(1)
        }
        .padding(.horizontal)
    }
}

struct CelebrationEffect: View {
    @ObservedObject private var appModel = AppModel.sharedAppModel
    var body: some View {
        VStack{
            VortexViewReader { proxy in
                VortexView(.confetti) {
                    Rectangle()
                        .fill(.white)
                        .frame(width: 30, height: 30)
                        .tag("square")
                    
                    Circle()
                        .fill(.white)
                        .frame(width: 30)
                        .tag("circle")
                }
                .onChange(of: appModel.shouldBurst) { newValue in
                    proxy.burst()
                }
            }
        }
        .allowsHitTesting(false)
        
    }
}
