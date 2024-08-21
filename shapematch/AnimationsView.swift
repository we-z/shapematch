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
