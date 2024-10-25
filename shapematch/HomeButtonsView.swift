//
//  HomeButtonsView.swift
//  Shape Swap
//
//  Created by Wheezy Capowdis on 10/11/24.
//

import SwiftUI

struct HomeButtonsView: View {
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @StateObject var audioController = AudioManager.sharedAudioManager
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    @State var showLevelsMenu = false
    var body: some View {
        HStack(spacing: idiom == .pad ? 39 : 9){
            Button {
                appModel.showGemMenu = true
            } label: {
                HStack{
                    Spacer()
                    Text("💎 \(userPersistedData.gemBalance)")
                        .bold()
                        .font(.system(size: deviceWidth/15))
                        .lineLimit(1)
                        .customTextStroke(width: 1.8)
                        .fixedSize()
                    Spacer()
                    
                }
                .frame(height: idiom == .pad ? deviceWidth/9 : deviceWidth/7)
                .background{
                    LinearGradient(gradient: Gradient(colors: [.teal, .blue]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
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
//                    appModel.showMovesCard = true
                } label: {
                    HStack{
                        Spacer()
                        Text("🛍️")
                            .bold()
                            .customTextStroke(width: 1.2)
                            .font(.system(size: deviceWidth/21))
                            .scaleEffect(idiom == .pad ? 1 : 1.3)
                            .fixedSize()
                        Spacer()
                        
                    }
                    .frame(height: idiom == .pad ? deviceWidth/9 : deviceWidth/7)
                    .background{
                        LinearGradient(gradient: Gradient(colors: [.yellow, .red]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
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
                    LinearGradient(gradient: Gradient(colors: [.purple, .indigo]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
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
    HomeButtonsView()
}
