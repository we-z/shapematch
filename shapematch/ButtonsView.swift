//
//  ButtonsView.swift
//  Shape Swap
//
//  Created by Wheezy Capowdis on 9/17/24.
//

import SwiftUI

struct ButtonsView: View {
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @StateObject var audioController = AudioManager.sharedAudioManager
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    var body: some View {
        HStack(spacing: idiom == .pad ? 21 : 9){
            Button {
                appModel.showGemMenu = true
            } label: {
                HStack{
                    Spacer()
                    Text("💎 \(userPersistedData.gemBalance)")
                        .bold()
                        .font(.system(size: deviceWidth/15))
                        .fixedSize()
                        .customTextStroke(width: 1.5)
                        .scaleEffect(idiom == .pad ? 1 : 1.2)
                    Spacer()
                        
                }
                .padding()
                .background{
                    Color.blue
                }
                .cornerRadius(15)
                .overlay{
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 5)
                        .padding(1)
                }
                .padding(3)
            }
            .buttonStyle(.roundedAndShadow6)
            ZStack{
                Button {
                    if appModel.undosLeft > 0 {
                        appModel.undoSwap()
                    } else {
                        if userPersistedData.gemBalance >= 3 {
                            userPersistedData.gemBalance -= 3
                            appModel.undosLeft = 3
                        } else {
                            appModel.showGemMenu = true
                        }
                    }
                } label: {
                    HStack{
                        Spacer()
                        Text("↩️ \(appModel.undosLeft)")
                            .bold()
                            .customTextStroke(width: 1.2)
                            .font(.system(size: deviceWidth/15))
                            .scaleEffect(idiom == .pad ? 1 : 1.2)
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
                .buttonStyle(.roundedAndShadow6)
                if appModel.undosLeft <= 0 {
                    ZStack {
                        Circle()
                            .frame(width: deviceWidth/6)
                            .foregroundColor(.blue)
                            .customTextStroke()
                        VStack(spacing: 6) {
                            Text("+ 3")
                                .bold()
                                .customTextStroke(width: 1)
                            Text("💎 1")
                                .bold()
                                .customTextStroke(width: 1)
                        }
                    }
                    .offset(x: deviceWidth/15, y:deviceWidth/7)
                    
                }
            }
            .simultaneousGesture(
                LongPressGesture(minimumDuration: 1.0) // Customize the duration (1 second here)
                    .onEnded { _ in
                        print("Long pressed!") // You can call a function here or trigger any action
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                                    showAlert = true
                            if !appModel.swapsMade.isEmpty {
                                impactHeavy.impactOccurred()
                            }
                            appModel.swapsMade = []
                            appModel.resetLevel()
                        }
                    }
            )
            .zIndex(1)
            
            Button{
                audioController.mute.toggle()
            } label: {
                HStack{
                    Spacer()
                    Text(audioController.mute ? "🔇" : "🔊")
                        .bold()
                        .italic()
                        .customTextStroke(width: 1.2)
                        .font(.system(size: deviceWidth/15))
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
            .buttonStyle(.roundedAndShadow6)
            .onChange(of: audioController.mute) { newSetting in
                audioController.setAllAudioVolume()
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    ButtonsView()
}
