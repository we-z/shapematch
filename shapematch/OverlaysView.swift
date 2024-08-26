//
//  OverlaysView.swift
//  shape match
//
//  Created by Wheezy Capowdis on 8/21/24.
//

import SwiftUI
import AVFoundation

struct OverlaysView: View {
    @ObservedObject private var appModel = AppModel.sharedAppModel
    var body: some View {
        ZStack {
            if !appModel.firstGamePlayed{
                HandSwipeView()
            }
            if appModel.showGemMenu {
                GemMenuView()
            } else if appModel.showNoMoreSwipesView {
                NoMoreSwipesView()
            }
            InstructionView()
            CelebrationEffect()
        }
    }
}

struct InstructionView: View {
    @State var cardOffset: CGFloat = 0
    @ObservedObject private var appModel = AppModel.sharedAppModel
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Text("↘️ Copy Goal ↙️")
                    .bold()
                    .font(.system(size: deviceWidth / 9))
                    .customTextStroke()
                Spacer()
            }
            .padding()
            .background(.yellow)
            .cornerRadius(15)
            .overlay{
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black, lineWidth: 6)
                    .padding(1)
            }
            .padding(.horizontal, 6)
            .offset(y: cardOffset)
            
            Spacer()
        }
        .onAppear{
            DispatchQueue.main.async {
                cardOffset = -(deviceWidth/2)
                withAnimation(.interpolatingSpring(mass: 2.0, stiffness: 100.0, damping: 10.0, initialVelocity: 0.0)) {
                    cardOffset = 0
                }
            }
        }
        .onChange(of: appModel.level) { level in
            if level > 1 {
                DispatchQueue.main.async {
                    withAnimation(.interpolatingSpring(mass: 2.0, stiffness: 100.0, damping: 10.0, initialVelocity: 0.0)) {
                        cardOffset = -(deviceWidth/2)
                    }
                }
            }
        }
    }
}

#Preview {
    OverlaysView()
}
