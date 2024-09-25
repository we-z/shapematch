//
//  iconview.swift
//  Shape Swap
//
//  Created by Wheezy Capowdis on 9/2/24.
//

import SwiftUI

struct iconview: View {
    @State private var grid: [[ShapeType]] = [
        [.circle, .star], // Updated to 4x4 grid with star shape
        [.square, .triangle]
    ]
    
    var body: some View {
        ZStack {
            Color.white
            VStack {
                ForEach(0..<2) { row in // Updated to 4 rows
                    HStack {
                        ForEach(0..<2) { column in // Updated to 4 columns
                            ShapeView(shapeType: grid[row][column])
                                .padding(18)
                            
                        }
                    }
                }
            }
            .scaleEffect(1.4)
        }
    }
}

struct ShapeView: View {
    let shapeType: ShapeType
    
    var body: some View {
        switch shapeType {
        case .circle:
            ZStack {
                Circle()
                    .fill(Color.black)
                    .scaleEffect(1.2)
                Circle()
                    .fill(Color.blue)
            }
            .frame(width: deviceWidth / 6, height: deviceWidth / 6)
        case .square:
            ZStack {
                Rectangle()
                    .fill(Color.black)
                    .cornerRadius(deviceWidth / 60)
                    .scaleEffect(1.21)
                Rectangle()
                    .fill(Color.red)
                    .cornerRadius(deviceWidth / 120)
            }
            .frame(width: deviceWidth / 6, height: deviceWidth / 6)
        case .triangle:
            ZStack {
                RoundedTriangle(cornerRadius: deviceWidth / 90)
                    .foregroundColor(.black)
                    .scaleEffect(1.21)
                RoundedTriangle(cornerRadius: deviceWidth / 180)
                    .foregroundColor(.green)
            }
            .frame(width: deviceWidth / 6, height: deviceWidth / 6)
            .scaleEffect(1.33)
            .offset(y: deviceWidth / 36)
            
        case .star:
            ZStack {
                RoundedStar(cornerRadius: deviceWidth / 180)
                    .foregroundColor(.black)
                    .scaleEffect(1.3)
                RoundedStar(cornerRadius: deviceWidth / 360)
                    .foregroundColor(.yellow)
            }
            .frame(width: deviceWidth / 6, height: deviceWidth / 6)
            .scaleEffect(1.15)
            .offset(y: deviceWidth / 120)
        case .hexagon:
            ZStack {
                RoundedHexagon(cornerRadius: deviceWidth / 75)
                    .foregroundColor(.black)
                    .scaleEffect(1.21)
                RoundedHexagon(cornerRadius: deviceWidth / 150)
                    .foregroundColor(.purple)
                
            }
            .scaleEffect(1.03)
            .frame(width: deviceWidth / 6, height: deviceWidth / 6)
        }
    }
}

#Preview {
    iconview()
}
