//
//  LevelCompleteView.swift
//  Shape Swap
//
//  Created by Wheezy Capowdis on 10/11/24.
//

import SwiftUI
import Vortex

struct LevelCompleteView: View {
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @State var buttonsnOffset = deviceWidth * 2
    @State var bannerOffset = -(deviceWidth)
    @State var show1Star = false
    @State var show2Stars = false
    @State var show3Stars = false
    @State var star1Size = 1.8
    @State var star2Size = 1.8
    @State var star3Size = 1.8
    
    
    func animateAwayButtonsAndBanner() {
        DispatchQueue.main.async { [self] in
            withAnimation(.linear(duration: 0.3)) {
                buttonsnOffset = deviceWidth * 2
                bannerOffset = -(deviceWidth)
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.5)
                .ignoresSafeArea()
            VStack{
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
                        .padding(.horizontal)
                    }
                    .buttonStyle(.roundedAndShadow6)
                    Spacer()
                }
                .offset(y: bannerOffset)
                Spacer()
                
                VStack{
                        Text("Level \(userPersistedData.level)")
                            .bold()
                            .font(.system(size: deviceWidth / 9))
                            .customTextStroke(width: 2.1)
                            .fixedSize()
                            .padding(.top)
                    Text("🥳")
                        .font(.system(size: deviceWidth / 6))
                        .customTextStroke(width: 2.7)
                        .padding(.bottom, 18)
                        .padding(.top, -6)
                    HStack{
                        ZStack {
                            Text("⭐️")
                                .customTextStroke(width: 2.7)
                                .opacity(0.2)
                            if show1Star {
                                Text("⭐️")
                                    .customTextStroke(width: 2.7)
                                    .scaleEffect(star1Size)
                                    .rotationEffect(.degrees((star1Size - 1) * 300))
                            }
                        }
                        ZStack {
                            Text("⭐️")
                                .customTextStroke(width: 2.7)
                                .opacity(0.2)
                            if show2Stars {
                                Text("⭐️")
                                    .customTextStroke(width: 2.7)
                                    .scaleEffect(star2Size)
                                    .rotationEffect(.degrees((star2Size - 1) * 300))
                            }
                            
                        }
                        .padding(.horizontal)
                        ZStack {
                            Text("⭐️")
                                .customTextStroke(width: 2.7)
                                .opacity(0.2)
                            if show3Stars {
                                Text("⭐️")
                                    .customTextStroke(width: 2.7)
                                    .scaleEffect(star3Size)
                                    .rotationEffect(.degrees((star3Size - 1) * 300))
                            }
                        }
                    }
                    .font(.system(size: deviceWidth / 6))
                    
                    .padding(1)
                    Button {
                        DispatchQueue.main.async { [self] in
                            withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                                animateAwayButtonsAndBanner()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                                    appModel.showLevelComplete = false
                                    userPersistedData.level += 1
                                    appModel.setupLevel()
                                }
                            }
                        }
                    } label: {
                        HStack{
                            Spacer()
                            Text("Continue  ➡️")
                                .italic()
                                .bold()
                                .font(.system(size: deviceWidth/12))
                                .fixedSize()
                                .customTextStroke(width: 1.8)
                            Spacer()
                        }
                        .padding()
                        .background{
                            LinearGradient(gradient: Gradient(colors: [.green, .green]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 0.3))
                        }
                        .cornerRadius(21)
                        .overlay{
                            RoundedRectangle(cornerRadius: 21)
                                .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 5)
                                .padding(1)
                        }
                        .padding(30)
                        
                    }
                    .buttonStyle(.roundedAndShadow6)
                }
                .background{
                    ZStack {
                        Color.white
                        Color.blue.opacity(0.6)
                    }
                }
                .cornerRadius(30)
                .overlay {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.yellow, lineWidth: idiom == .pad ? 11 : 6)
                        .padding(1)
                        .shadow(radius: 3)
                }
                .shadow(radius: 3)
                .padding()
                .offset(y: buttonsnOffset)
            }
//            VortexViewReader { proxy in
//                VortexView(.confetti) {
//                    Rectangle()
//                        .fill(.white)
//                        .frame(width: 30, height: 30)
//                        .tag("square")
//                    
//                    Circle()
//                        .fill(.white)
//                        .frame(width: 30)
//                        .tag("circle")
//                }
//                .onChange(of: appModel.shouldBurst) { _ in
//                    proxy.burst()
//                }
//            }
//            .allowsHitTesting(false)
        }
        .onAppear {
            DispatchQueue.main.async { [self] in
                withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 24.0, initialVelocity: 0.0)) {
                    bannerOffset = 0
                    buttonsnOffset = 0
                    appModel.shouldBurst.toggle()
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [self] in
                if appModel.swipesLeft >= 0 || userPersistedData.level == 1 {
                    show1Star = true
                    withAnimation {
                        star1Size = 1
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                if appModel.swipesLeft >= 1 || userPersistedData.level == 1 {
                    show2Stars = true
                    withAnimation {
                        star2Size = 1
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) { [self] in
                if appModel.swipesLeft >= 2 || userPersistedData.level == 1 {
                    show3Stars = true
                    withAnimation {
                        star3Size = 1
                    }
                }
            }
        }
    }
}

#Preview {
    LevelCompleteView()
}
