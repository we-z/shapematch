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
        CelebrateLineup()
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
        .allowsHitTesting(false)
    }
}

struct SunView: View {
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
        }
        .allowsHitTesting(false)
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
                Color.black.opacity(0.001)
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
                    .onAppear {
                        DispatchQueue.main.async {
                            showMessage = true
                            if userPersistedData.hapticsOn {
                                hapticManager.notification(type: .error)
                            }
                            withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 200.0, damping: 13.0, initialVelocity: -10.0)) {
                                showAnimation = true
                                animateMessage = true
                                currentMessage = messages.randomElement() ?? "Well Done!"
                            }
                            
                            // Ensure particles are emitting before the burst
                            proxy.particleSystem?.isEmitting = true
                            proxy.burst()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                                if userPersistedData.hapticsOn {
                                    hapticManager.notification(type: .error)
                                }
                                withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10.0, initialVelocity: 0.0)) {
                                    animateMessage = false
                                }
                                showAnimation = false
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
                    .offset(y: animateMessage ? 0 : -(deviceHeight/1.8))
            }
            VStack {
                Spacer()
                Text("Tap to skip")
                    .bold()
                    .font(.system(size: deviceWidth / 18))
                    .customTextStroke(width: 1.5)
                    .padding()
            }
        }
        .onTapGesture {
            print("tapped Celebration")
            appModel.showCelebration = false
            withAnimation {
                appModel.showLevelComplete = true
            }
        }
    }
}

struct NewLevelAnimation: View {
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    // Array of congratulatory messages
    
    // State to hold the current message
    @State private var showAnimation = false
    @State private var showLevel = false

    var body: some View {
        ZStack{
            if showAnimation {
                Color.black.opacity(0.6)
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
                    .onAppear {
                        DispatchQueue.main.async {
                            if userPersistedData.hapticsOn {
                                hapticManager.notification(type: .error)
                            }
                            withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 200.0, damping: 13.0, initialVelocity: -10.0)) {
                                showAnimation = true
                                showLevel = true
                            }
                            
                            // Ensure particles are emitting before the burst
                            proxy.particleSystem?.isEmitting = true
//                            proxy.burst()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
                                if userPersistedData.hapticsOn {
                                    hapticManager.notification(type: .error)
                                }
                                withAnimation() {
                                    showAnimation = false
                                    showLevel = false
                                   
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                                    appModel.showNewLevelAnimation = false
                                }
                            }
                            
                        }
                    }
                }
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
        .onTapGesture {
            appModel.showNewLevelAnimation = false
        }
    }
}

struct CelebrateLineup: View {
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    // Array of congratulatory messages
    
    // State to hold the current message
    @State private var showAnimation = false
    @State private var showLevel = false

    var body: some View {
        ZStack{
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
                    .onChange(of: appModel.celebrateLineup) { _ in
                        DispatchQueue.main.async {
                            if userPersistedData.hapticsOn {
                                hapticManager.notification(type: .error)
                            }
                            withAnimation(.interpolatingSpring(mass: 1.5, stiffness: 200.0, damping: 13.0, initialVelocity: -10.0)) {
                                showAnimation = true
                                showLevel = true
                            }
                            
                            // Ensure particles are emitting before the burst
                            proxy.particleSystem?.isEmitting = true
                            proxy.burst()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [self] in
                                withAnimation() {
                                    showAnimation = false
                                    showLevel = false
                                   
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                                    appModel.showNewLevelAnimation = false
                                }
                            }
                            
                        }
                    }
                }
            }
            ZStack{
                Text("🙌")
                    .font(.system(size: deviceWidth / 6))
                    .customTextStroke(width: 1.8)
                    .fixedSize()
                    .rotationEffect(.degrees(showLevel ? 0 : -180))
            }
            .scaleEffect(showLevel ? 1 : 0.001)
        }
        .allowsHitTesting(false)
    }
}

struct CelebrateGems: View {
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @State var bannerOffset = -(deviceWidth/2)
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    
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
                        AudioServicesPlaySystemSound(1335)
                        DispatchQueue.main.async {
                            showMessage = true
                            if userPersistedData.hapticsOn {
                                hapticManager.notification(type: .error)
                            }
                            withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 200.0, damping: 13.0, initialVelocity: -10.0)) {
                                animateMessage = true
                                bannerOffset = 0
                            }
                            
                            // Ensure particles are emitting before the burst
                            proxy.particleSystem?.isEmitting = true
                            proxy.burst()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
                                if userPersistedData.hapticsOn {
                                    hapticManager.notification(type: .error)
                                }
                                withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10.0, initialVelocity: 0.0)) {
                                    animateMessage = false
                                    bannerOffset = -(deviceWidth/2)
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
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
    @State private var viewID = UUID()  // Add a unique identifier to track view appearance

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
        .id(viewID)  // Ensure the view is reloaded on appearance
        .onAppear {
            resetAndStartAnimation()
        }
        .onDisappear {
            cancelAnimation()  // Cancel animations when the view disappears
        }
        .allowsHitTesting(false)
    }
    
    func resetAndStartAnimation() {
        // Reset state variables
        offsetAmount = 0
        rotateHand = false
        fade = false
        
        // Start the animation
        animate()
    }

    func cancelAnimation() {
        // This function can be used to handle any required cleanup
        // For example, you could invalidate any timers or DispatchQueues if needed.
        viewID = UUID()  // Force reloading the view by changing its ID
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
                    offsetAmount = -(deviceWidth/6)
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
