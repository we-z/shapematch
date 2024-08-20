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
        CelebrationEffect()
    }
}

#Preview {
    AnimationsView()
}

struct  CelebrationEffect: View {
    @State private var burstCount = 0

    var body: some View {
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
                    // Start a timer when the view appears
                    proxy.burst()
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                        if burstCount < 0 {
                            // Call proxy.burst() every second
                            proxy.burst()
                            burstCount += 1
                        } else {
                            // Invalidate the timer after bursting 3 times
                            timer.invalidate()
                        }
                    }
                }
            }
        }
        .allowsHitTesting(false)
        
    }
}
