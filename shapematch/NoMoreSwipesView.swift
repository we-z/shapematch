//
//  NoMoreSwipesView.swift
//  shape match
//
//  Created by Wheezy Capowdis on 8/20/24.
//

import SwiftUI
import AVFoundation

struct NoMoreSwipesView: View {
    
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @State var buttonsnOffset = deviceWidth
    @State var bannerOffset = -(deviceWidth/2)
    @State var pulseText = true
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    
    func resetGame() {
        appModel.resetLevel()
        appModel.showNoMoreSwipesView = false
        appModel.showInstruction.toggle()
    }
    
    func animateAwayButtonsAndBanner() {
        DispatchQueue.main.async { [self] in
            withAnimation(.linear(duration: 0.3)) {
                buttonsnOffset = deviceWidth
                bannerOffset = -(deviceWidth/2)
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.7)
                .ignoresSafeArea()
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            if gesture.translation.height > 0 {
                                buttonsnOffset = gesture.translation.height
                            } else if gesture.translation.height < 0 {
                                bannerOffset = gesture.translation.height
                            }
                        }
                        .onEnded { _ in
                            DispatchQueue.main.async { [self] in
                                withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                                    buttonsnOffset = 0
                                    bannerOffset = 0
                                }
                            }
                        }
                )
            VStack{
                HStack {
                    Spacer()
                    Text("0 Moves left ✋")
                        .bold()
                        .font(.system(size: deviceWidth/9))
                        .customTextStroke(width: 2.4)
                    Spacer()
                }
                .padding(12)
                .background(.red)
                .cornerRadius(21)
                .overlay{
                    RoundedRectangle(cornerRadius: 21)
                        .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 6)
                        .padding(1)
                }
                .padding(.top)
                .offset(y: bannerOffset)
                .gesture(
                    DragGesture(minimumDistance: 1, coordinateSpace: .local)
                        .onEnded { value in
                            if value.translation.height < 0 {
                                // Swipe up detected
                                DispatchQueue.main.async { [self] in
                                    withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                                        bannerOffset = -(deviceWidth/2)
                                    }
                                }
                            }
                        }
                )
                Spacer()
                VStack(spacing: idiom == .pad ? 18 : 6){
                    HStack(spacing: idiom == .pad ? 18 : 9){
                        Button {
                            animateAwayButtonsAndBanner()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                                appModel.showNoMoreSwipesView = false
                                appModel.setupLevel()
                            }
                        } label: {
                            HStack {
                                Spacer()
                                Text("🔀")
                                    .font(.system(size: deviceWidth/12))
                                    .customTextStroke(width: 2)
                                    .fixedSize()
                                    .padding([.trailing], 9)
                                Spacer()
                            }
                            .padding()
                            .background{
                                Color.green
                            }
                            .cornerRadius(15)
                            .overlay{
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 5)
                                    .padding(1)
                            }
                            .padding(3)
                        }
                        Button {
                            animateAwayButtonsAndBanner()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                                resetGame()
                            }
                        } label: {
                            HStack{
                                Spacer()
                                Text("🔁")
                                    .font(.system(size: deviceWidth/12))
                                    .customTextStroke(width: 2)
                                    .fixedSize()
                                    .padding([.trailing], 9)
                                Spacer()
                            }
                            .padding()
                            .background{
                                Color.red
                            }
                            .cornerRadius(15)
                            .overlay{
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 5)
                                    .padding(1)
                            }
                            .padding(3)
                        }
                    }
                    .buttonStyle(.roundedAndShadow6)
                    .padding(.bottom, 6)
                    Button {
                        animateAwayButtonsAndBanner()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                            if appModel.swapsToSell > userPersistedData.gemBalance {
                                appModel.showGemMenu = true
                            } else {
                                userPersistedData.decrementBalance(amount: appModel.swapsToSell)
                                appModel.swipesLeft += appModel.swapsToSell
                                appModel.showNoMoreSwipesView = false
                            }
                        }
                    } label: {
                        HStack{
                            Spacer()
                            Text("💎 + \(appModel.swapsToSell) Moves ↔️")
                                .bold()
                                .font(.system(size: deviceWidth/12))
                                .fixedSize()
                                .customTextStroke(width: 2.1)
                                .padding(.horizontal, 9)
                            Spacer()
                        }
                        .padding()
                        .background(.blue)
                        .cornerRadius(21)
                        .overlay{
                            RoundedRectangle(cornerRadius: 21)
                                .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 5)
                                .padding(1)
                        }
                        .padding(.bottom, 15)
                        
                    }
                    .buttonStyle(.roundedAndShadow6)
                }
                .offset(y: buttonsnOffset)
                
            }
            .padding(.horizontal, 18)
            .background(.clear)
            .scaleEffect(idiom == .pad ? 0.84 : 1)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                    buttonsnOffset = 0
                }
            }
            DispatchQueue.main.async { [self] in
                withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                    bannerOffset = 0
                }
            }
        }
    }
}

#Preview {
    NoMoreSwipesView()
}
