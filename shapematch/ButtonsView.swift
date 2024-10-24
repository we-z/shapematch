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
    @State var showLevelsMenu = false
    var body: some View {
        HStack(spacing: idiom == .pad ? 39 : 9){
            Button{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    appModel.selectedTab = 1
                    withAnimation {
                        appModel.selectedTab = 0
                    }
                }
            } label: {
                HStack{
                    Spacer()
                    Text("⬅️")
                        .bold()
                        .italic()
                        .customTextStroke(width: 1.2)
                        .fixedSize()
                        .font(.system(size: deviceWidth/21))
                        .scaleEffect(idiom == .pad ? 1 : 1.2)
                    Spacer()
                        
                }
                .frame(height: idiom == .pad ? deviceWidth/9 : deviceWidth/7)
                .background{
                    LinearGradient(gradient: Gradient(colors: [.red, .red]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                }
                .cornerRadius(idiom == .pad ? 30 : 15)
                .overlay{
                    RoundedRectangle(cornerRadius: idiom == .pad ? 30 : 15)
                        .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 5)
                        .padding(1)
                }
                .padding(3)
            }
            .buttonStyle(.roundedAndShadow6)

            ZStack{
                Button {
                    appModel.undoSwap()
                } label: {
                    HStack{
                        Spacer()
                        Text("↩️  \(appModel.undosLeft)")
                            .bold()
                            .customTextStroke(width: 1.2)
                            .font(.system(size: deviceWidth/21))
                            .scaleEffect(idiom == .pad ? 1 : 1.3)
                            .fixedSize()
                        Spacer()
                        
                    }
                    .frame(height: idiom == .pad ? deviceWidth/9 : deviceWidth/7)
                    .background{
                        LinearGradient(gradient: Gradient(colors: [.mint, .green]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 0.5))
                    }
                    .cornerRadius(idiom == .pad ? 30 : 15)
                    .overlay{
                        RoundedRectangle(cornerRadius: idiom == .pad ? 30 : 15)
                            .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 5)
                            .padding(1)
                    }
                    .padding(3)
                }
                .buttonStyle(.roundedAndShadow6)
                if appModel.undosLeft <= 0 {
                    ZStack {
                        Circle()
                            .frame(width: idiom == .pad ? deviceWidth/8.5 : deviceWidth/6)
                            .foregroundColor(.black)
                            .scaleEffect(idiom == .pad ? 1.2 : 1)
                        Circle()
                            .frame(width: idiom == .pad ? deviceWidth/8 : deviceWidth/7)
                            .overlay {
                                LinearGradient(gradient: Gradient(colors: [.teal, .blue]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                                    .mask(Circle())
                            }
                        VStack(spacing: 6) {
                            Text("+ 3")
                                .bold()
                                .font(.system(size: deviceWidth / 21))
                                .customTextStroke(width: 1)
                                .fixedSize()
                            Text("💎 1")
                                .bold()
                                .font(.system(size: deviceWidth / 27))
                                .customTextStroke(width: 1)
                                .fixedSize()
                        }
                        .font(.system(size: idiom == .pad ? 36 : 12))
                    }
                    .offset(x: deviceWidth/12, y: idiom == .pad ? deviceWidth/12 : deviceWidth/9)
                    .compositingGroup()
                }
            }
            .zIndex(1)
            Button{
                appModel.showSettings = true
            } label: {
                HStack{
                    Spacer()
                    Text("⚙️")
                        .bold()
                        .italic()
                        .customTextStroke(width: 1.2)
                        .fixedSize()
                        .font(.system(size: deviceWidth/21))
                        .scaleEffect(idiom == .pad ? 1 : 1.3)
                    Spacer()
                        
                }
                .frame(height: idiom == .pad ? deviceWidth/9 : deviceWidth/7)
                .background{
                    LinearGradient(gradient: Gradient(colors: [.purple, .purple]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 0.8))
                }
                .cornerRadius(idiom == .pad ? 30 : 15)
                .overlay{
                    RoundedRectangle(cornerRadius: idiom == .pad ? 30 : 15)
                        .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 5)
                        .padding(1)
                }
                .padding(3)
            }
            .buttonStyle(.roundedAndShadow6)
        }
        .padding(.horizontal, idiom == .pad ? 39 : 15)
        .sheet(isPresented: self.$showLevelsMenu){
            LevelsView()
        }
    }
}

#Preview {
    ButtonsView()
}
