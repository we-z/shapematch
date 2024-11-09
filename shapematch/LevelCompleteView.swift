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
    @State var gemXoffset = 0.0
    @State var gemYoffset: CGFloat = -deviceHeight
    @State var gemScale = 1.0
    @State var leftScreen = false  // New state variable
    
    func animateAwayButtonsAndBanner() {
        DispatchQueue.main.async { [self] in
            withAnimation(.linear(duration: 0.3)) {
                cardOffset = deviceWidth * 2
                bannerOffset = -(deviceWidth)
            }
        }
    }
    
    func goBack() {
        leftScreen = true
        
        DispatchQueue.main.async { [self] in
            withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                animateAwayButtonsAndBanner()
                if userPersistedData.hapticsOn {
                    impactLight.impactOccurred()
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            appModel.showLevelComplete = false
            appModel.resetLevel()
        }
    }
    
    func continueNextLevel() {
        leftScreen = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
            withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                animateAwayButtonsAndBanner()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                    appModel.showLevelComplete = false
                    userPersistedData.level += 1
                    appModel.setupLevel()
                    appModel.showNewLevelAnimation = true
                }
            }
        }
    }
    
    func rewardGem() {
        withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 21.0, initialVelocity: 0.0)) {
            gemYoffset = -(deviceWidth / 2)
        }
        if userPersistedData.hapticsOn {
            impactLight.impactOccurred()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) { [self] in
            if userPersistedData.hapticsOn {
                impactLight.impactOccurred()
            }
            withAnimation {
                gemXoffset = -(deviceWidth / 2.8)
                gemYoffset = -(deviceHeight / 2.5)
                gemScale = 0.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                userPersistedData.incrementBalance(amount: 1)
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.6)
                .ignoresSafeArea()
//                .onTapGesture {
//                    goBack()
//                }
//                .gesture(
//                    DragGesture()
//                        .onEnded { gesture in
//                            if gesture.translation.height > 0 {
//                                DispatchQueue.main.async { [self] in
//                                    withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
//                                        goBack()
//                                    }
//                                }
//                            }
//                        }
//                )
            ZStack {
                RotatingSunView()
                    .frame(width: 1, height: 1)
                    .fixedSize()
                    .scaleEffect(0.75)
                Text("💎")
                    .font(.system(size: idiom == .pad ?  deviceWidth / 6 : deviceWidth / 3))
                    .customTextStroke(width: 4)
                    
            }
            .scaleEffect(gemScale)
            .offset(x: gemXoffset, y: gemYoffset)
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
                                .padding(.horizontal, idiom == .pad ? 30 : 21)
                            
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
                        .padding(.horizontal, idiom == .pad ? 30 : 15)
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
                           .font(.system(size: deviceWidth / 12))
                           .customTextStroke(width: 2.1)
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
                   .padding()
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
                        if !leftScreen {
                            continueNextLevel()
                        }
                    } label: {
                        HStack{
                            Spacer()
                            Text("Continue  ➡️")
                                .bold()
                                .font(.system(size: deviceWidth/12))
                                .fixedSize()
                                .customTextStroke(width: 2.1)
                            Spacer()
                        }
                        .padding()
                        .background{
                            LinearGradient(gradient: Gradient(colors: [.green, .green]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 0.5))
                        }
                        .cornerRadius(21)
                        .overlay{
                            RoundedRectangle(cornerRadius: 21)
                                .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 5)
                                .padding(1)
                        }
                        .padding(idiom == .pad ? 60 : 39)
                        
                    }
                    .buttonStyle(.roundedAndShadow6)
                }
                .background{
                    LinearGradient(gradient: Gradient(colors: [.blue, .blue]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 0.6))
                }
                .cornerRadius(39)
                .overlay {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.yellow, lineWidth: idiom == .pad ? 12 : 9)
                        .padding(1)
                        .shadow(radius: 3)
                        .padding()
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
            .padding(idiom == .pad ? 30 : 0)
        }
        .onAppear {
            DispatchQueue.main.async { [self] in
                appModel.showCelebration = false
                withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 24.0, initialVelocity: 0.0)) {
                    bannerOffset = 0
                    cardOffset = 0
                    appModel.shouldBurst.toggle()
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [self] in
                if leftScreen { return }
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
                if leftScreen { return }
                if appModel.swipesLeft >= 1 || userPersistedData.level == 1 {
                    appModel.swipesLeft -= 1
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
                if leftScreen { return }
                if appModel.swipesLeft >= 1 || userPersistedData.level == 1 {
                    appModel.swipesLeft -= 1
                    if userPersistedData.hapticsOn {
                        hapticManager.notification(type: .error)
                    }
                    show3Stars = true
                    withAnimation {
                        star3Size = 1
                    }
                }
            }
            DispatchQueue.main.async{ [self] in
                if appModel.shouldRewardGem {
                    rewardGem()
                    appModel.shouldRewardGem = false
                }
            }
        }
    }
}

#Preview {
    LevelCompleteView()
}
