//
//  iconview.swift
//  Shape Swap
//
//  Created by Wheezy Capowdis on 9/2/24.
//

import SwiftUI

struct iconview: View {
    @State private var grid: [[ShapeType]] = [
        [.triangle, .circle], // Updated to 4x4 grid with star shape
        [.square, .star]
    ]
    
    var body: some View {
        ZStack {
            Color.blue
            LinearGradient(
                gradient: Gradient(colors: [.purple, .blue, .teal]),
                startPoint: UnitPoint(x: 0.4, y: 0.2),
                endPoint: UnitPoint(x: 0.6, y: 0.8)
            )
            RotatingSunView()
            ZStack {
                Text("💎")
                    .font(.system(size: 270))
                    .customTextStroke(width: 6)
            }
        }
    }
}

#Preview {
    iconview()
}
