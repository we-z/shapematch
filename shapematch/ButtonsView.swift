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
                        .font(.system(size: deviceWidth/21))
                        .lineLimit(1 )
                        .customTextStroke(width: 1.5)
                        .scaleEffect(idiom == .pad ? 1 : 1.2)
                    Spacer()
                        
                }
                .padding(.vertical)
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
            
            Button{
                audioController.mute.toggle()
            } label: {
                HStack{
                    Spacer()
                    Text(audioController.mute ? "🔇" : "🔊")
                        .bold()
                        .italic()
                        .customTextStroke(width: 1.2)
                        .font(.system(size: deviceWidth/21))
                        .scaleEffect(idiom == .pad ? 1 : 1.2)
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
            ZStack{
                Button {
                    if appModel.undosLeft > 0 {
                        appModel.undoSwap()
                    } else {
                        if userPersistedData.gemBalance >= 1 {
                            userPersistedData.gemBalance -= 1
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
                            .font(.system(size: deviceWidth/21))
                            .scaleEffect(idiom == .pad ? 1 : 1.2)
                        Spacer()
                        
                    }
                    .padding(.vertical)
                    .background{
                        Color.yellow
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
                            .frame(width: deviceWidth/8)
                            .foregroundColor(.black)
                            .scaleEffect(idiom == .pad ? 1.2 : 1)
                        Circle()
                            .frame(width: idiom == .pad ? deviceWidth/10 : deviceWidth/9)
                            .foregroundColor(.blue)
                        VStack(spacing: 3) {
                            Text("+ 3")
                                .bold()
                                .customTextStroke(width: 1)
                            Text("💎 1")
                                .bold()
                                .customTextStroke(width: 1)
                        }
                        .font(.system(size: idiom == .pad ? 36 : 12))
                    }
                    .offset(x: deviceWidth/18, y: idiom == .pad ? deviceWidth/12 : deviceWidth/12)
                    .compositingGroup()
                }
            }
            .zIndex(1)
            Button{
                appModel.swapsMade = []
                appModel.resetLevel()
            } label: {
                HStack{
                    Spacer()
                    Text("🔁")
                        .bold()
                        .italic()
                        .customTextStroke(width: 1.2)
                        .font(.system(size: deviceWidth/21))
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
