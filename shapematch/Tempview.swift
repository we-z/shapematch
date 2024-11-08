//
//  ContentView.swift
//  shapematch
//
//  Created by Wheezy Capowdis on 8/17/24.
//

import SwiftUI
import MetalKit

struct TempView: View {
    @State private var animate = false

        var body: some View {
            VStack {
                Text("Smooth SwiftUI Animation")
                    .font(.title)
                    .padding()

                RoundedRectangle(cornerRadius: 25)
                    .fill(animate ? Color.green : Color.blue)
                    .frame(width: animate ? 200 : 100, height: animate ? 200 : 100)
                    .animation(
                        .linear(duration: 0.6), // Longer, smooth animation to reduce perceived lag
                        value: animate
                    )

                Button("Toggle Animation") {
                    animate.toggle()
                }
                .padding()
            }
        }
    
}

#Preview {
    TempView()
}
