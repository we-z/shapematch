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
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.7)
                .ignoresSafeArea()
                .gesture(
                    DragGesture(minimumDistance: 1, coordinateSpace: .local)
                        .onEnded { value in
                            if value.translation.height < 0 {
                                // Swipe up detected
                                DispatchQueue.main.async { [self] in
                                    withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                                        buttonsnOffset = 0
                                    }
                                }
                            }
                            if value.translation.height > 0 {
                                // Swipe down detected
                                DispatchQueue.main.async { [self] in
                                    if bannerOffset == 0 {
                                        withAnimation(.linear) {
                                            buttonsnOffset = deviceWidth
                                        }
                                    }
                                    withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                                        bannerOffset = 0
                                    }
                                }
                            }
                        }
                )
            VStack{
                HStack {
                    Spacer()
                    Text("0 Swaps left ✋")
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
                        .stroke(Color.black, lineWidth: 6)
                        .padding(1)
                }
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
                VStack(spacing: 21){
                    HStack{
                        Button {
                            resetGame()
                            impactHeavy.impactOccurred()
                        } label: {
                            Text("🔀")
                                .font(.system(size: deviceWidth/6))
                                .customTextStroke(width: 2)
                                .padding([.trailing], 9)
                        }
                        Spacer()
                        Button {
                            resetGame()
                            impactHeavy.impactOccurred()
                        } label: {
                            Text("🔄")
                                .font(.system(size: deviceWidth/6))
                                .customTextStroke(width: 2)
                                .padding([.trailing], 9)
                        }
                    }
                    .buttonStyle(.roundedAndShadow6)
                    Button {
                        if appModel.swapsToSell > userPersistedData.gemBalance {
                            appModel.showGemMenu = true
                        } else {
                            userPersistedData.decrementBalance(amount: appModel.swapsToSell)
                            appModel.swipesLeft += appModel.swapsToSell
                            appModel.showNoMoreSwipesView = false
                        }
                    } label: {
                        HStack{
                            Spacer()
                            Text("💎")
                                .bold()
                                .italic()
                                .font(.system(size: deviceWidth/13))
                                .fixedSize()
                                .scaleEffect(1.5)
                                .customTextStroke(width: 2.4)
                            
                            Text("+ \(appModel.swapsToSell) Swaps")
                                .bold()
                                .font(.system(size: deviceWidth/10))
                                .fixedSize()
                                .customTextStroke(width: 2.4)
                                .padding(.horizontal, 9)
                            Text("↔️")
                                .bold()
                                .italic()
                                .font(.system(size: deviceWidth/13))
                                .fixedSize()
                                .scaleEffect(1.2)
                                .customTextStroke(width: 2.4)
                            Spacer()
                        }
                        .padding()
                        .background(.blue)
                        .cornerRadius(21)
                        .overlay{
                            RoundedRectangle(cornerRadius: 21)
                                .stroke(Color.black, lineWidth: 5)
                                .padding(1)
                        }
                        .padding(.bottom, 21)
                        
                    }
                    .buttonStyle(.roundedAndShadow6)
                }
                .gesture(
                    DragGesture(minimumDistance: 1, coordinateSpace: .local)
                        .onEnded { value in
                            if value.translation.height > 0 {
                                // Swipe up detected
                                DispatchQueue.main.async { [self] in
                                    withAnimation(.linear) {
                                        buttonsnOffset = deviceWidth
                                    }
                                }
                            }
                        }
                )
                .offset(y: buttonsnOffset)
                
            }
            .padding(.horizontal)
            .background(.clear)
        }
        .onAppear {
            AudioServicesPlaySystemSound (1053)
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
