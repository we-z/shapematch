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

struct ShapeView: View {
    let shapeType: ShapeType
    
    var body: some View {
        switch shapeType {
        case .circle:
            ZStack {
//                Circle()
//                    .fill(Color.black)
//                    .scaleEffect(1.2)
//                Circle()
//                    .fill(Color.blue)
                Text("🔵")
                    .font(.system(size: idiom == .pad ? 90 : 53))
                    .customTextStroke()
                    .scaleEffect(1.5)
            }
            .frame(width: deviceWidth / 6, height: deviceWidth / 6)
        case .square:
            ZStack {
//                Rectangle()
//                    .fill(Color.black)
//                    .cornerRadius(deviceWidth / 60)
//                    .scaleEffect(1.21)
//                Rectangle()
//                    .fill(Color.red)
//                    .cornerRadius(deviceWidth / 120)
                Text("🟩")
                    .font(.system(size: idiom == .pad ? 90 : 53))
                    .customTextStroke()
                    .scaleEffect(1.5)
            }
            .frame(width: deviceWidth / 6, height: deviceWidth / 6)
        case .triangle:
            ZStack {
//                RoundedTriangle(cornerRadius: deviceWidth / 90)
//                    .foregroundColor(.black)
//                    .scaleEffect(1.21)
//                RoundedTriangle(cornerRadius: deviceWidth / 180)
//                    .foregroundColor(.green)
            Text("🔻")
                    .font(.system(size: idiom == .pad ? 90 : 53))
                .customTextStroke(width: 1)
                .scaleEffect(2.4)
            }
            .frame(width: deviceWidth / 6, height: deviceWidth / 6)
//            .scaleEffect(1.33)
//            .offset(y: deviceWidth / 120)
            
        case .star:
            ZStack {
//                RoundedStar(cornerRadius: deviceWidth / 180)
//                    .foregroundColor(.black)
//                    .scaleEffect(1.5)
//                RoundedStar(cornerRadius: deviceWidth / 360)
//                    .foregroundColor(.yellow)
                Text("⭐️")
                    .font(.system(size: idiom == .pad ? 90 : 53))
                    .customTextStroke()
                    .scaleEffect(1.7)
            }
            .frame(width: deviceWidth / 6, height: deviceWidth / 6)
//            .scaleEffect(1)
//            .offset(y: deviceWidth / 120)
        case .heart:
            ZStack {
                Text("💜")
                    .font(.system(size: idiom == .pad ? 90 : 53))
                    .customTextStroke()
                    .scaleEffect(1.6)
                
            }
//            .scaleEffect(1.03)
            .frame(width: deviceWidth / 6, height: deviceWidth / 6)
        }
    }
}

#Preview {
    iconview()
}
