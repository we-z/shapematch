//
//  ContentView.swift
//  shapematch
//
//  Created by Wheezy Capowdis on 8/17/24.
//

import SwiftUI

struct TempView: View {
    
    @State private var grid: [[ShapeType]] = [
        [.square, .triangle, .circle, .star], // Updated to 4x4 grid with star shape
        [.triangle, .square, .circle, .star],
        [.square, .circle, .triangle, .star],
        [.circle, .triangle, .square, .star]
    ]
    
    var body: some View {
        ZStack {
            VStack {
                ForEach(0..<4) { row in // Updated to 4 rows
                    HStack {
                        ForEach(0..<4) { column in // Updated to 4 columns
                            LargeShapeView(shapeType: grid[row][column])
                                .frame(width: deviceWidth / 6, height: deviceWidth / 6) // Adjusted size for 4x4 grid
                                .padding(15)
                        }
                    }
                }
            }
            .scaleEffect(0.9)
        }
    }
}

#Preview {
    TempView()
}
