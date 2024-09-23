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
                            LargeShapeView(shapeType: grid[row][column])
                                .frame(width: deviceWidth / 8, height: deviceWidth / 8)
                                .padding(12)
                            
                        }
                    }
                }
            }.scaleEffect(1.5)
        }
    }
}

//struct iconview: View {
//    var body: some View {
//        ZStack {
//            Color.white
//           
//            LargeShapeView(shapeType: .circle)
//                .frame(width: 160)
//                .offset(x: -30 ,y: 66)
//            
//            LargeShapeView(shapeType: .square)
//                .frame(width: 130, height: 130)
//                .offset(x: 33 ,y: 0)
//            LargeShapeView(shapeType: .triangle)
//                .frame(width: 130, height: 130)
//                .rotationEffect(.degrees(12))
//                .offset(x: 45 ,y:60)
//            
//            LargeShapeView(shapeType: .star)
//                .customTextStroke(width: 0)
//                .scaleEffect(2.1)
//                .frame(width: 80)
//                .rotationEffect(.degrees(-12))
//                .offset(x: -45 ,y: 15)
//            
//        }
//    }
//}

#Preview {
    iconview()
}
