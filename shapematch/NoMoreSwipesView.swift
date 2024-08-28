//
//  NoMoreSwipesView.swift
//  shape match
//
//  Created by Wheezy Capowdis on 8/20/24.
//

import SwiftUI

struct NoMoreSwipesView: View {
    
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @State var cardOffset = deviceWidth
    @State var pulseText = true
    @ObservedObject var userPersistedData = UserPersistedData()
    
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
                Spacer()
                VStack{
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
                        .cornerRadius(15)
                        .overlay{
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.black, lineWidth: 4)
                                .padding(1)
                        }
                        .padding()
                    }
                    .buttonStyle(.roundedAndShadow6)
                    Button {
                        resetGame()
                    } label: {
                        HStack{
                            Text("🔄")
                                .font(.system(size: deviceWidth/15))
                                .customTextStroke(width: 1.2)
                                .padding(.horizontal)
                        }
                        .padding(.vertical, 14)
                        .frame(width: deviceWidth/3.3)
                        .background{
                            Color.red
                        }
                        .cornerRadius(15)
                        .overlay{
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.black, lineWidth: 4)
                                .padding(1)
                        }
                    }
                    .buttonStyle(.roundedAndShadow6)
                    .padding(.bottom)
                }
                .padding()
                .background(.red)
                .cornerRadius(30)
                .overlay{
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.black, lineWidth: 7)
                        .padding(1)
                }
                .padding()
                .offset(y: cardOffset)
            }
            
        }
        .onAppear {
            DispatchQueue.main.async {
                withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 15.0, initialVelocity: 0.0)) {
                    cardOffset = 0
                }
            }
        }
    }
}

#Preview {
    NoMoreSwipesView()
}
