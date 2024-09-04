//
//  NoMoreSwipesView.swift
//  shape match
//
//  Created by Wheezy Capowdis on 8/20/24.
//

import SwiftUI

struct NoMoreSwipesView: View {
    
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @State var buySwapsButtonOffset = deviceWidth/3
    @State var resetButtonOffset = -(deviceWidth/3)
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
                .onTapGesture {
                    resetGame()
                }
            Text("0 Swaps left ✋")
                .bold()
                .font(.system(size: deviceWidth/9))
                .customTextStroke(width: 2.4)
                .pulsingText()
                .allowsHitTesting(false)
            VStack {
                
                VStack{

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
                                .font(.system(size: deviceWidth/15))
                                .fixedSize()
                                .scaleEffect(1.5)
                                .customTextStroke(width: 1.8)
                            
                            Text("+ \(appModel.swapsToSell) Swaps")
                                .bold()
                                .font(.system(size: deviceWidth/12))
                                .fixedSize()
                                .customTextStroke(width: 1.8)
                                .padding(.horizontal, 9)
                            Text("↔️")
                                .bold()
                                .italic()
                                .font(.system(size: deviceWidth/15))
                                .fixedSize()
                                .scaleEffect(1.2)
                                .customTextStroke(width: 1.2)
                            Spacer()
                        }
                        .padding()
                        .background(.blue)
                        .cornerRadius(21)
                        .overlay{
                            RoundedRectangle(cornerRadius: 21)
                                .stroke(Color.black, lineWidth: 4)
                                .padding(1)
                        }
//                        .padding()
                    }
                    .buttonStyle(.roundedAndShadow6)
                    .offset(y: buySwapsButtonOffset)
                    
                }
                .padding()
                .background(.clear)
                
            }
            
        }
        .onAppear {
            DispatchQueue.main.async {
                withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 15.0, initialVelocity: 0.0)) {
                    buySwapsButtonOffset = 0
                    resetButtonOffset = -(deviceWidth/30)
                }
            }
        }
    }
}

#Preview {
    NoMoreSwipesView()
}
