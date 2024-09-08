//
//  ContentView.swift
//  shapematch
//
//  Created by Wheezy Capowdis on 8/17/24.
//

import SwiftUI

struct TempView: View {
    
    @State var grid: [[ShapeType]] = [
        [.square, .triangle, .circle, .star, .hexagon], // Updated to 4x4 grid with star shape
        [.triangle, .square, .circle, .star, .hexagon],
        [.square, .circle, .triangle, .star, .hexagon],
        [.circle, .triangle, .square, .star, .hexagon],
        [.circle, .triangle, .square, .star, .hexagon]
    ]
    
    var body: some View {
        ZStack {
            VStack {
                ForEach(0..<3) { row in // Updated to 4 rows
                    HStack {
                        ForEach(0..<3) { column in // Updated to 4 columns
                            LargeShapeView(shapeType: grid[row][column])
                                .frame(width: deviceWidth / ((3 - 1 ) * 2.3), height: deviceWidth / ((3 - 1 ) * 2.3)) // Adjusted size for 4x4 grid
                                .padding(15)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    TempView()
}
