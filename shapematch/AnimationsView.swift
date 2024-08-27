//
//  AnimationsView.swift
//  shapematch
//
//  Created by Wheezy Capowdis on 8/18/24.
//

import SwiftUI
import Vortex

struct AnimationsView: View {
    @ObservedObject private var appModel = AppModel.sharedAppModel
    var body: some View {
        Rectangle()
            .frame(width: 100, height: 100)
            .pulsingPlaque()
    }
}

#Preview {
    AnimationsView()
}


struct CelebrationEffect: View {
    @ObservedObject private var appModel = AppModel.sharedAppModel

    // Array of congratulatory messages
    private let messages = ["Well Done!", "Great Job!", "You Did It!", "Awesome!"]
    
    // State to hold the current message
    @State private var currentMessage = ""
    @State private var showMessage = false
    @State private var animateMessage = false

    var body: some View {
        let hapticManager = HapticManager.instance
        ZStack{
            if animateMessage {
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
                                animateMessage = true
                                currentMessage = messages.randomElement() ?? "Well Done!"
                            }
                            
                            proxy.burst()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
                                hapticManager.notification(type: .error)
                                withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10.0, initialVelocity: 0.0)) {
                                    animateMessage = false
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
                Text(currentMessage)
                    .bold()
                    .italic()
                    .font(.system(size: deviceWidth / 9))
                    .customTextStroke(width: 2.4)
                    .rotationEffect(.degrees(animateMessage ? 0 : -180))
                    .scaleEffect(animateMessage ? 1 : 0.1)
                    .offset(y: animateMessage ? 0 : -(deviceHeight/2))
            }
        }
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
                    .stroke(Color.black, lineWidth: 9.0 - -(offsetAmount/30))
                    .frame(width: (deviceWidth/5))
                    .opacity(rotateHand ? 0.5 : 0)
                    .padding(21)
                    .scaleEffect(1 - (offsetAmount/60))
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
                    .onAppear {
                        animate()
                    }
            }
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
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .onAppear {
                if !appModel.firstGamePlayed{
                    runAnimation()
                }
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
            if appModel.level < 2 {
                runAnimation()
            }
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
