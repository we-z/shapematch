//
//  SettingsView.swift
//  Shape Swap
//
//  Created by Wheezy Capowdis on 10/11/24.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var audioController = AudioManager.sharedAudioManager
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    @State var cardOffset: CGFloat = deviceHeight
    var body: some View {
        ZStack{
            Color.gray.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    DispatchQueue.main.async { [self] in
                        withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                            cardOffset = deviceWidth * 2
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                                if userPersistedData.hapticsOn {
                                    impactLight.impactOccurred()
                                }
                                appModel.showSettings = false
                            }
                        }
                    }
                }
                .gesture(
                    DragGesture()
                        .onEnded { gesture in
                            if gesture.translation.height > 0 {
                                DispatchQueue.main.async { [self] in
                                    withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                                        cardOffset = deviceWidth * 2
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                                            if userPersistedData.hapticsOn {
                                                impactLight.impactOccurred()
                                            }
                                            appModel.showSettings = false
                                        }
                                    }
                                }
                            }
                        }
                )
            VStack {
                Spacer()
                VStack {
                    VStack{
                        Capsule()
                            .foregroundColor(.blue)
                            .frame(width: 45, height: 9)
                            .customTextStroke()
                        HStack {
                            Text("Settings ⚙️")
                                .bold()
                                .font(.system(size: deviceWidth / 12))
                                .customTextStroke()
                                .padding(.vertical)
                        }
                        HStack {
                            Text("🎵")
                                .bold()
                                .font(.system(size: deviceWidth / 9))
                                .customTextStroke(width: 1.2)
                                .multilineTextAlignment(.leading)
                                .fixedSize()
                            Spacer()
                            Toggle("", isOn: $audioController.musicOn )
                                .offset(x: -(deviceWidth/9))
                                .scaleEffect(1.5)
                            
                            
                        }
                        HStack {
                            Text("🔊")
                                .bold()
                                .font(.system(size: deviceWidth / 9))
                                .customTextStroke(width: 1.8)
                                .multilineTextAlignment(.leading)
                                .fixedSize()
                            Spacer()
                            Toggle("", isOn: $userPersistedData.soundOn )
                                .offset(x: -(deviceWidth/9))
                                .scaleEffect(1.5)
                        }
                        .padding(.vertical)
                        HStack {
                            Text("📳")
                                .bold()
                                .font(.system(size: deviceWidth / 9))
                                .customTextStroke(width: 1.8)
                                .multilineTextAlignment(.leading)
                                .fixedSize()
                            Spacer()
                            Toggle("", isOn: $userPersistedData.hapticsOn )
                                .offset(x: -(deviceWidth/9))
                                .scaleEffect(1.5)
                        }
                        .padding(.bottom, 30)
                    }
                    .padding(30)
                }
                .background{
                    LinearGradient(gradient: Gradient(colors: [.teal, .blue]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                }
                .cornerRadius(30)
                .overlay{
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.black, lineWidth: 9)
                        .padding(1)
                }
                .offset(y: cardOffset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            cardOffset = gesture.translation.height
                        }
                        .onEnded { gesture in
                            if gesture.translation.height > 0 {
                                DispatchQueue.main.async { [self] in
                                    withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                                        cardOffset = deviceHeight
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                                            if userPersistedData.hapticsOn {
                                                impactLight.impactOccurred()
                                            }
                                            appModel.showSettings = false
                                        }
                                    }
                                }
                            } else {
                                DispatchQueue.main.async { [self] in
                                    withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                                        cardOffset = 0
                                    }
                                }
                            }
                        }
                )
                .padding()
            }
            .onAppear {
                DispatchQueue.main.async {
                    withAnimation(.interpolatingSpring(mass: 2.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                        cardOffset = 0
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
