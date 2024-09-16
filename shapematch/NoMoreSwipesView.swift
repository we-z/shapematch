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
    @State var buySwapsButtonOffset = deviceWidth/2
    @State var resetButtonOffset = -(deviceWidth/2)
    @State var pulseText = true
    @State var textScale: CGFloat = 3
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
                                    withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 9.0, initialVelocity: 0.0)) {
                                        buySwapsButtonOffset = 0
                                    }
                                }
                            }
                            if value.translation.height > 0 {
                                // Swipe up detected
                                DispatchQueue.main.async { [self] in
                                    withAnimation(.linear) {
                                        buySwapsButtonOffset = deviceWidth/3
                                    }
                                }
                            }
                        }
                )
//            ZStack {
                FailFireEffect()
                    .frame(width: deviceWidth)
                    .offset(y: deviceWidth/15)
                Text("0 Swaps left ✋")
                    .bold()
                    .font(.system(size: deviceWidth/9))
                    .customTextStroke(width: 2.4)
                
                    .allowsHitTesting(false)
//            }
            .scaleEffect(textScale)
            VStack{
                HStack{
                    Spacer()
                    Button {
                        resetGame()
                        impactHeavy.impactOccurred()
                    } label: {
                        Text("🔄")
                            .font(.system(size: deviceWidth/6))
                            .customTextStroke(width: 2)
                            .padding([.trailing], 9)
                            .offset(y: resetButtonOffset)
                    }
                }
                .buttonStyle(.roundedAndShadow6)
                Spacer()
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
                    .padding(.bottom, 6)
                    .gesture(
                        DragGesture(minimumDistance: 1, coordinateSpace: .local)
                            .onEnded { value in
                                if value.translation.height > 0 {
                                    // Swipe up detected
                                    DispatchQueue.main.async { [self] in
                                        withAnimation(.linear) {
                                            buySwapsButtonOffset = deviceWidth/3
                                        }
                                    }
                                }
                            }
                    )
                }
                .buttonStyle(.roundedAndShadow6)
                .offset(y: buySwapsButtonOffset)
                
            }
            .padding()
            .background(.clear)
        }
        .onAppear {
            AudioServicesPlaySystemSound (1053)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 9.0, initialVelocity: 0.0)) {
                    buySwapsButtonOffset = 0
                    resetButtonOffset = 0
                }
            }
            DispatchQueue.main.async {
                withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 120.0, damping: 16.0, initialVelocity: 0.0)) {
                    textScale = 1
                }
            }
        }
    }
}

#Preview {
    NoMoreSwipesView()
}
