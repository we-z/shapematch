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
            VStack(spacing: 12) {

                Text("🌁 🌉 San Francisco")
                    .italic()
                    .bold()
                    .customTextStroke(width: 1.8)
                    .font(.system(size: 36))
                
                Text("🏎️ 💨 Swifty Fridays")
                    .italic()
                    .bold()
                    .customTextStroke(width: 1.8)
                    .font(.system(size: 36))
            }
            .padding(30)
            .padding(.vertical, 100)
            .background{
                LinearGradient(gradient: Gradient(colors: [.orange, .red]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
            }
        }
    
}

#Preview {
    TempView()
}
