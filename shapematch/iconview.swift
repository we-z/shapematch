//
//  iconview.swift
//  Shape Swap
//
//  Created by Wheezy Capowdis on 9/2/24.
//

import SwiftUI

struct iconview: View {
    @State private var grid: [[ShapeType]] = [
        [.square, .triangle, .circle], // Updated to 4x4 grid with star shape
        [.triangle, .square, .circle],
        [.square, .circle, .triangle]
    ]
    
    var body: some View {
        ZStack {
            Color.white
            VStack {
                ForEach(0..<3) { row in // Updated to 4 rows
                    HStack {
                        ForEach(0..<3) { column in // Updated to 4 columns
                            LargeShapeView(shapeType: grid[row][column])
                                .frame(width: deviceWidth / 8, height: deviceWidth / 8)
                                .padding(18)
                            
                        }
                    }
                }
            }.scaleEffect(1.03)
        }
    }
}

#Preview {
    iconview()
}
