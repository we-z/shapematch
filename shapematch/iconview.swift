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
                                .padding(6)
                            
                        }
                    }
                }
            }.scaleEffect(3)
        }
    }
}

#Preview {
    iconview()
}
