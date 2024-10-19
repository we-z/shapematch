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
    @State var bannerOffset = -(deviceWidth)
    @State var pulseText = true
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    
    func resetGame() {
        appModel.resetLevel()
        appModel.showNoMoreSwipesView = false
        if userPersistedData.level != 1 {
            appModel.showInstruction.toggle()
        }
    }
    
    func animateAwayButtonsAndBanner() {
        DispatchQueue.main.async { [self] in
            withAnimation(.linear(duration: 0.3)) {
                buttonsnOffset = deviceWidth
                bannerOffset = -(deviceWidth)
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.7)
                .ignoresSafeArea()
//                .onTapGesture {
//                    animateAwayButtonsAndBanner()
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
//                        resetGame()
//                    }
//                }
//                .gesture(
//                    DragGesture()
//                        .onChanged { gesture in
//                            if gesture.translation.height > 0 {
//                                buttonsnOffset = gesture.translation.height
//                            } else if gesture.translation.height < 0 {
//                                bannerOffset = gesture.translation.height
//                            }
//                        }
//                        .onEnded { _ in
//                            DispatchQueue.main.async { [self] in
//                                withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
//                                    buttonsnOffset = 0
//                                    bannerOffset = 0
//                                }
//                            }
//                        }
//                )
            VStack{
                VStack {
                    HStack {
                        Button {
                            appModel.showGemMenu = true
                        } label: {
                            HStack{
                                Text("💎 \(userPersistedData.gemBalance)")
                                    .bold()
                                    .font(.system(size: deviceWidth/15))
                                    .lineLimit(1)
                                    .customTextStroke(width: 1.8)
                                    .fixedSize()
                                    .padding(.horizontal)
                                
                            }
                            .frame(height: idiom == .pad ? deviceWidth/9 : deviceWidth/7)
                            .background{
                                LinearGradient(gradient: Gradient(colors: [.teal, .blue]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                            }
                            .cornerRadius(18)
                            .overlay{
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 5)
                                    .padding(1)
                            }
                            .padding(3)
                        }
                        .buttonStyle(.roundedAndShadow6)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text("0 Moves left! ✋")
                            .bold()
                            .font(.system(size: deviceWidth/9))
                            .customTextStroke(width: 2.4)
                            .fixedSize()
                        Spacer()
                    }
                    .padding(12)
                    .background{
                        LinearGradient(gradient: Gradient(colors: [.red, .red]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 0.2))
                    }
                    .cornerRadius(21)
                    .overlay{
                        RoundedRectangle(cornerRadius: 21)
                            .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 6)
                            .padding(1)
                    }
                    .padding(.top)
                }
                .offset(y: bannerOffset)
                Spacer()
                VStack(spacing: idiom == .pad ? 18 : 6){
                    Text("Continue?")
                        .bold()
                        .font(.system(size: deviceWidth / 9))
                        .customTextStroke(width: 2.4)
                        .padding()
                        Button {
                            animateAwayButtonsAndBanner()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                                if 9 > userPersistedData.gemBalance {
                                    appModel.showGemMenu = true
                                } else {
                                    userPersistedData.decrementBalance(amount: 3)
                                    appModel.swipesLeft += 3
                                    appModel.showNoMoreSwipesView = false
                                }
                            }
                        } label: {
                            HStack{
                                Text("+ 3 Moves")
                                    .bold()
                                    .font(.system(size: deviceWidth/12))
                                    .fixedSize()
                                    .customTextStroke(width: 2.1)
                                    .padding(.leading)
                                Spacer()
                                Text("💎 9")
                                    .bold()
                                    .font(.system(size: deviceWidth/12))
                                    .fixedSize()
                                    .customTextStroke(width: 2.1)
                                    .padding(.trailing)
                                
                            }
                            .padding()
                            .background{
                                LinearGradient(gradient: Gradient(colors: [.teal, .blue]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                            }
                            .cornerRadius(21)
                            .overlay{
                                RoundedRectangle(cornerRadius: 21)
                                    .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 5)
                                    .padding(1)
                            }
                            .padding(.bottom, 9)
                            
                        }
                        .buttonStyle(.roundedAndShadow6)
                    HStack(spacing: idiom == .pad ? 18 : 9){
                        Button {
                            animateAwayButtonsAndBanner()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                                resetGame()
                            }
                        } label: {
                            HStack{
                                Spacer()
                                Text("❌")
                                    .font(.system(size: deviceWidth/12))
                                    .customTextStroke(width: 3)
                                    .fixedSize()
                                    .padding([.trailing], 9)
                                Spacer()
                            }
                            .padding()
                            .background{
                                LinearGradient(gradient: Gradient(colors: [.red, .red]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 0.2))
                            }
                            .cornerRadius(21)
                            .overlay{
                                RoundedRectangle(cornerRadius: 21)
                                    .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 5)
                                    .padding(1)
                            }
                            .padding(3)
                            .padding(.bottom)
                        }
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
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
//                withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
//                    buttonsnOffset = 0
//                }
//            }
            DispatchQueue.main.async { [self] in
                withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                    bannerOffset = 0
                    buttonsnOffset = 0
                }
            }
        }
    }
}

#Preview {
    NoMoreSwipesView()
}
