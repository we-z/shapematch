//
//  AnimationsView.swift
//  shapematch
//
//  Created by Wheezy Capowdis on 8/18/24.
//

import SwiftUI
import Vortex
import AVFoundation

struct AnimationsView: View {
    @ObservedObject private var appModel = AppModel.sharedAppModel
    var body: some View {
        CelebrationEffect()
            .onAppear {
                appModel.shouldBurst.toggle()
            }
    }
}

#Preview {
    AnimationsView()
}

struct RotatingSunView: View {
    @State private var rotationAngle: Double = 0

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color.clear)
                    .frame(width: 600, height: 600)
                
                
                ForEach(0..<12) { index in
                    ForEach(0..<15) { index2 in
                        SunRayView(index: index)
                            .rotationEffect(.degrees(Double(index2)))
                    }
                }
            }
            .rotationEffect(.degrees(rotationAngle))
            .onAppear {
                withAnimation(Animation.linear(duration: 12).repeatForever(autoreverses: false)) {
                    self.rotationAngle = 360
                }
            }
        }
    }
}

struct SunRayView: View {
    let index: Int

    var body: some View {
        Rectangle()
            .fill(LinearGradient(
                colors: [.clear, .white.opacity(0.1)],
                startPoint: .top,
                endPoint: .bottom
            ))
            .frame(width: 6, height: 300)
            .offset(y: -150)
            .rotationEffect(.degrees(Double(index) * 30))
    }
}

struct CelebrationEffect: View {
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    @StateObject var audioController = AudioManager.sharedAudioManager
    // Array of congratulatory messages
    private let messages = ["Well Done!", "Great Job!", "You Did It!", "Awesome!"]
    
    // State to hold the current message
    @State private var currentMessage = ""
    @State private var showMessage = false
    @State private var showAnimation = false
    @State private var showLevel = false
    @State private var animateMessage = false

    var body: some View {
        ZStack{
            if showAnimation {
                Color.gray.opacity(0.7)
                    .ignoresSafeArea()
            }
            VStack{
                VortexViewReader { proxy in
                    VortexView(.confetti) {
                        Rectangle()
                            .fill(.white)
                            .frame(width: 30, height: 30)
                            .tag("square")
                        
                        Circle()
                            .fill(.white)
                            .frame(width: 30)
                            .tag("circle")
                    }
                    .onChange(of: appModel.shouldBurst) { newValue in
                        
                        DispatchQueue.main.async {
                            showMessage = true
                            hapticManager.notification(type: .error)
                            withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 200.0, damping: 13.0, initialVelocity: -10.0)) {
                                showAnimation = true
                                animateMessage = true
                                currentMessage = messages.randomElement() ?? "Well Done!"
                            }
                            
                            // Ensure particles are emitting before the burst
                            proxy.particleSystem?.isEmitting = true
                            proxy.burst()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
                                hapticManager.notification(type: .error)
                                audioController.musicPlayer.setVolume(0, fadeDuration: 1)
                                withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10.0, initialVelocity: 0.0)) {
                                    animateMessage = false
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                                    showMessage = false
                                    proxy.burst()
                                    withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 200.0, damping: 13.0, initialVelocity: -10.0)) {
                                        showLevel = true
                                    }
                                }
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [self] in
                                appModel.freezeGame = false
                                withAnimation(.linear) {
                                    showLevel = false
                                    showAnimation = false
                                }
                                if userPersistedData.level == 2 {
                                    appModel.showNewGoal.toggle()
                                }
                                if userPersistedData.level < 5 {
                                    appModel.showInstruction.toggle()
                                }
                            }
                        }
                    }
                }
            }
            if showMessage {
                Text(currentMessage)
                    .bold()
                    .italic()
                    .font(.system(size: deviceWidth / 9))
                    .customTextStroke(width: 2.4)
                    .fixedSize()
                    .rotationEffect(.degrees(animateMessage ? 0 : -180))
                    .scaleEffect(animateMessage ? 1 : 0.1)
                    .offset(y: animateMessage ? 0 : -(deviceHeight/2))
            }
            ZStack{
                RotatingSunView()
                    .frame(width: 1, height: 1)
//                    .offset(y: deviceWidth / 7.5)
                Text("Level\n\(userPersistedData.level)")
                    .bold()
                    .italic()
                    .multilineTextAlignment(.center)
                    .font(.system(size: deviceWidth / 4.5))
                    .customTextStroke(width: 3.3)
                    .fixedSize()
                    .rotationEffect(.degrees(showLevel ? 0 : -180))
                    .offset(y: -(deviceWidth / 7.5))
            }
                
                .scaleEffect(showLevel ? 1 : 0.001)
        }
        .allowsHitTesting(false)
    }
}

struct CelebrateGems: View {
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @State var bannerOffset = -(deviceWidth/2)
    @StateObject var audioController = AudioManager.sharedAudioManager
    
    // State to hold the current message
    @State private var showMessage = false
    @State private var animateMessage = false

    var body: some View {
        ZStack{
            if animateMessage {
                Color.blue.opacity(0.3)
                    .ignoresSafeArea()
            }
            VStack{
                VortexViewReader { proxy in
                    VortexView(.confetti) {
                        Rectangle()
                            .fill(.white)
                            .frame(width: 30, height: 30)
                            .tag("square")
                        
                        Circle()
                            .fill(.white)
                            .frame(width: 30)
                            .tag("circle")
                    }
                    .onChange(of: appModel.boughtGems) { newValue in
                        audioController.musicPlayer.setVolume(0, fadeDuration: 1)
                        AudioServicesPlaySystemSound(1335)
                        DispatchQueue.main.async {
                            showMessage = true
                            hapticManager.notification(type: .error)
                            withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 200.0, damping: 13.0, initialVelocity: -10.0)) {
                                animateMessage = true
                                bannerOffset = 0
                            }
                            
                            // Ensure particles are emitting before the burst
                            proxy.particleSystem?.isEmitting = true
                            proxy.burst()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
                                hapticManager.notification(type: .error)
                                withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10.0, initialVelocity: 0.0)) {
                                    animateMessage = false
                                    bannerOffset = -(deviceWidth/2)
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                                    audioController.musicPlayer.setVolume(1, fadeDuration: 1)
                                    showMessage = false
                                }
                            }
                        }
                    }
                }
            }
            if showMessage {
                Text("💎 +\(appModel.amountBought) Gems!")
                    .bold()
                    .italic()
                    .font(.system(size: deviceWidth / 9))
                    .customTextStroke(width: 2.4)
                    .fixedSize()
                    .rotationEffect(.degrees(animateMessage ? 0 : -180))
                    .scaleEffect(animateMessage ? 1 : 0.1)
                    .offset(y: animateMessage ? 0 : -(deviceHeight/2))
            }
            VStack {
                HStack {
                    Spacer()
                    Text("💸 Success! 💸")
                        .bold()
                        .font(.system(size: deviceWidth/9))
                        .customTextStroke(width: 2.4)
                        .fixedSize()
                    Spacer()
                }
                .padding(12)
                .background(.blue)
                .cornerRadius(21)
                .overlay{
                    RoundedRectangle(cornerRadius: 21)
                        .stroke(Color.black, lineWidth: 6)
                        .padding(1)
                }
                .padding(.horizontal)
                .offset(y: bannerOffset)
                Spacer()
            }
        }
        .allowsHitTesting(false)
    }
}

struct FailFireEffect: View {
    var body: some View {
        ZStack{
            VortexView(.fire) {
                Circle()
                    .fill(.white)
                    .frame(width: 45)
                    .blur(radius: 1)
                    .blendMode(.plusLighter)
                    .tag("circle")
            }
        }
        .frame(width: deviceWidth*8)
        .allowsHitTesting(false)
    }
}

struct SwapParticleEffect: View {
    var body: some View {
        ZStack{
            VortexViewReader { proxy in
                VortexView(.confetti) {
                    Circle()
                        .fill(.purple)
                        .frame(width: 30)
                        .tag("circle")
                    
                    Circle()
                        .fill(.orange)
                        .frame(width: 30)
                        .tag("circle")
                    
                    Circle()
                        .fill(.pink)
                        .frame(width: 30)
                        .tag("circle")
                }
                
                .onAppear{
                    proxy.burst()
                }
            }
        }
        .scaleEffect(0.3)
        .allowsHitTesting(false)
    }
}

struct HandSwipeView: View {

    @State private var offsetAmount: CGFloat = 0
    @State private var rotateHand = false
    @State private var fade = true

    var body: some View {
        
        ZStack{
            VStack{
                Spacer()
                Circle()
                    .stroke(Color.black, lineWidth: deviceWidth/45 - -(offsetAmount/30))
                    .frame(width: (deviceWidth/5))
                    .opacity(rotateHand ? 0.6 : 0)
                    .padding(21)
                    .scaleEffect(1 - (offsetAmount/(deviceWidth*0.15)))
            }
            VStack{
                Spacer()
                Text("👆")
                    .rotationEffect(.degrees(rotateHand ? -40 : -30))
                    .font(.system(size: deviceWidth/3))
                    .customTextStroke(width: 3)
                    .offset(x: deviceWidth / 7, y: deviceWidth / 7)
                    .offset(y: offsetAmount)
                    .opacity(fade ? 0 : 1)
                    .scaleEffect(fade ? 0.9 : 1)
                    
            }
        }
        .offset(y: idiom == .pad ? 51 : -33)
        .onAppear {
            animate()
        }
        .allowsHitTesting(false)
    }
    
    func animate() {
        DispatchQueue.main.async{
            withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10.0, initialVelocity: 0.0)) {
                fade = false
            }
            offsetAmount = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 5.0, initialVelocity: 0.0)) {
                    rotateHand = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(Animation.easeInOut(duration: 1.5)) {
                    offsetAmount = -(deviceWidth/3.3)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10.0, initialVelocity: 0.0)) {
                        rotateHand = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10.0, initialVelocity: 0.0)) {
                            fade = true
                        }
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                animate()
            }
        }
    }
    
}

struct ScalingText: ViewModifier {
    
    var speed: CGFloat = 1
    var size: CGFloat = 1.1
    
    @State private var scale: CGFloat = 1.0
    @State private var repeatAnimation = false
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @State var pulseCount = 0
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .onAppear {
                runAnimation()
            }
    }

    private func runAnimation() {
        withAnimation(.easeInOut(duration: speed)) {
            scale = size
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + speed) {
            withAnimation(.easeInOut(duration: speed)) {
                scale = 1.0
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + speed * 2) {
            withAnimation(.easeInOut(duration: speed)) {
                scale = size
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + speed * 3) {
            withAnimation(.easeInOut(duration: speed)) {
                scale = 1.0
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + speed * 4) {
            pulseCount += 1
            if pulseCount < 1 {
                runAnimation()
            }
        }
    }
}

struct ScalingPlaque: ViewModifier {
    
    var speed: CGFloat = 1
    var size: CGFloat = 1.1
    
    @State private var scale: CGFloat = 1.0
    @State private var repeatAnimation = false
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .offset(y: (scale - 1.0) * (deviceHeight / 9))
            .onAppear {
                if userPersistedData.level == 1 {
                    scale = 1.5
                }
            }
            .onChange(of: userPersistedData.level) { level in
                if level == 1 {
                    scale = 1.5
                }
            }
            .onChange(of: appModel.showInstruction) { _ in
                runAnimation()
            }
    }

    private func runAnimation() {
        impactLight.impactOccurred()
        withAnimation(.easeInOut(duration: speed)) {
            scale = size
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + speed) {
            withAnimation(.easeInOut(duration: speed)) {
                scale = 1.0
                
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + speed * 2) {
            impactLight.impactOccurred()
        }
    }
}

extension View {
    func pulsingText(speed: CGFloat = 0.6, size: CGFloat = 1.1) -> some View {
        self.modifier(ScalingText(speed: speed, size: size))
    }
}

extension View {
    func pulsingPlaque(speed: CGFloat = 1, size: CGFloat = 1.1) -> some View {
        self.modifier(ScalingPlaque(speed: speed, size: size))
    }
}
