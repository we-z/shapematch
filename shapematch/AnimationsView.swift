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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
                        .frame(width: 16, height: 16)
                        .tag("square")
                    
                    Circle()
                        .fill(.white)
                        .frame(width: 16)
                        .tag("circle")
                }
                .onAppear {
                    // Start a timer when the view appears
                    proxy.burst()
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                        if burstCount < 3 {
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
