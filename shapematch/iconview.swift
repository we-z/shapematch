//
//  iconview.swift
//  Shape Swap
//
//  Created by Wheezy Capowdis on 9/2/24.
//

import SwiftUI

struct iconview: View {
    @State private var grid: [[ExtendedShapeType]] = [
        [.square, .triangle, .circle], // Updated to 4x4 grid with star shape
        [.triangle, .square, .circle],
        [.square, .circle, .triangle]
    ]
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1)
            VStack {
                ForEach(0..<3) { row in // Updated to 4 rows
                    HStack {
                        ForEach(0..<3) { column in // Updated to 4 columns
                            ExtendedLargeShapeView(shapeType: grid[row][column])
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
    iconview()
}
