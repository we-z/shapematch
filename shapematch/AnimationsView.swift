//
//  AnimationsView.swift
//  shapematch
//
//  Created by Wheezy Capowdis on 8/18/24.
//

import SwiftUI
import Vortex

struct AnimationsView: View {
    var body: some View {
        HandSwipeView()
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
                        showMessage = true
                        withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10.0, initialVelocity: 0.0)) {
                            animateMessage = true
                            currentMessage = messages.randomElement() ?? "Well Done!"
                        }
                        
                        proxy.burst()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
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
            if showMessage {
                Text(currentMessage)
                    .bold()
                    .italic()
                    .font(.system(size: deviceWidth / 9))
                    .customTextStroke()
                    .rotationEffect(.degrees(animateMessage ? 0 : -180))
                    .scaleEffect(animateMessage ? 1 : 0.1)
                    .offset(y: animateMessage ? 0 : -(deviceHeight/2))
            }
        }
        .allowsHitTesting(false)
    }
}

struct HandSwipeView: View {

    @State private var offsetAmount: CGFloat = 30
    @State private var rotateHand = false
    @State private var fade = true
    @State private var isAnimating = false

    var body: some View {
        VStack{
            Spacer()
            Text("👆")
                .rotationEffect(.degrees(rotateHand ? -40 : -30))
                .font(.system(size: deviceWidth/3))
                .customTextStroke(width: 3)
                .offset(x: deviceWidth / 9, y: deviceWidth / 6)
                .offset(y: offsetAmount)
                .opacity(fade ? 0 : 1)
                .scaleEffect(fade ? 0.9 : 1)
                .onAppear {
                    animate()
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
            withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10.0, initialVelocity: 0.0)) {
                rotateHand = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10.0, initialVelocity: 0.0)) {
                    rotateHand = false
                }
                withAnimation(Animation.easeInOut(duration: 1.5)) {
                    offsetAmount = -(deviceWidth/3.3)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10.0, initialVelocity: 0.0)) {
                        rotateHand = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10.0, initialVelocity: 0.0)) {
                            rotateHand = false
                        }
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
