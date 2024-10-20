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
    @State var cardOffset = deviceWidth * 2
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
                cardOffset = deviceWidth * 2
                bannerOffset = -(deviceWidth)
            }
        }
    }
    
    func goBack() {
        DispatchQueue.main.async { [self] in
            withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                animateAwayButtonsAndBanner()
                if userPersistedData.hapticsOn {
                    impactLight.impactOccurred()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                    withAnimation {
                        appModel.showCelebration = false
                        appModel.showLevelComplete = false
                        appModel.selectedTab = 0
                    }
                }
            }
        }
    }
    
    func rewardGem() {
        
    }
    
    var body: some View {
        ZStack {
            Color.gray
                .opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture {
                    goBack()
                }
                .gesture(
                    DragGesture()
                        .onEnded { gesture in
                            if gesture.translation.height > 0 {
                                DispatchQueue.main.async { [self] in
                                    withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                                        goBack()
                                    }
                                }
                            }
                        }
                )
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
                    HStack{
                       Text("❌")
                           .bold()
                           .font(.system(size: deviceWidth / 12))
                           .customTextStroke(width: 1.5)
                           .fixedSize()
                           .padding(.top)
                           .opacity(0)
                       Spacer()
                       Text("Level \(userPersistedData.level)")
                           .bold()
                           .font(.system(size: deviceWidth / 9))
                           .customTextStroke(width: 2.4)
                           .fixedSize()
                           .padding(.top)
                       Spacer()
                       Button {
                           goBack()
                       } label: {
                           Text("❌")
                               .bold()
                               .font(.system(size: deviceWidth / 12))
                               .customTextStroke(width: 1.8)
                               .fixedSize()
                               .padding(.top)
                       }
                   }
                   .padding(.horizontal, 30)
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                            withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                                animateAwayButtonsAndBanner()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                                    appModel.showLevelComplete = false
                                    appModel.showCelebration = false
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
                                .customTextStroke(width: 2.1)
                            Spacer()
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
                        .padding(30)
                        
                    }
                    .buttonStyle(.roundedAndShadow6)
                }
                .background{
                    LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 0.6))
                }
                .cornerRadius(30)
                .overlay {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.yellow, lineWidth: idiom == .pad ? 12 : 9)
                        .padding(1)
                        .shadow(radius: 3)
                }
                .shadow(radius: 3)
                .padding()
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
                                        goBack()
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
                    cardOffset = 0
                    appModel.shouldBurst.toggle()
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [self] in
                if appModel.swipesLeft >= 0 || userPersistedData.level == 1 {
                    if userPersistedData.hapticsOn {
                        hapticManager.notification(type: .error)
                    }
                    show1Star = true
                    withAnimation {
                        star1Size = 1
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                if appModel.swipesLeft >= 1 || userPersistedData.level == 1 {
                    if userPersistedData.hapticsOn {
                        hapticManager.notification(type: .error)
                    }
                    show2Stars = true
                    withAnimation {
                        star2Size = 1
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) { [self] in
                if appModel.swipesLeft >= 2 || userPersistedData.level == 1 {
                    if userPersistedData.hapticsOn {
                        hapticManager.notification(type: .error)
                    }
                    show3Stars = true
                    withAnimation {
                        star3Size = 1
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
//                        if let levelStars = userPersistedData.levelStars[String(userPersistedData.level)] {
//                            if levelStars < 3 {
                                rewardGem()
//                            }
//                        }
                    }
                }
            }
        }
    }
}

#Preview {
    LevelCompleteView()
}
