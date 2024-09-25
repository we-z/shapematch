//
//  ContentView.swift
//  shapematch
//
//  Created by Wheezy Capowdis on 8/17/24.
//

import SwiftUI

struct TempView: View {
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @State var grid: [[ShapeType]] = [
        [.square, .triangle, .circle, .star, .heart], // Updated to 4x4 grid with star shape
        [.triangle, .square, .circle, .star, .heart],
        [.square, .circle, .triangle, .star, .heart],
        [.circle, .triangle, .square, .star, .heart],
        [.circle, .triangle, .square, .star, .heart]
    ]
    
    @State var grid2: [[ShapeType]] = [
        [.square, .triangle, .circle, .star], // Updated to 4x4 grid with star shape
        [.triangle, .square, .circle, .star],
        [.square, .circle, .triangle, .star],
        [.circle, .triangle, .square, .star]
    ]
    
    var body: some View {
        ZStack {
            VStack {
                ForEach(0..<grid2.count, id: \.self) { row in // Updated to 4 rows
                    HStack {
                        ForEach(0..<grid2.count, id: \.self) { column in // Updated to 4 columns
                            ShapeView(shapeType: grid2[row][column])
                                .frame(width: deviceWidth / ((CGFloat(grid2.count) - 1 ) * 2.3), height: deviceWidth / ((CGFloat(grid2.count) - 1 ) * 2.3)) // Adjusted size for 4x4 grid
                                .padding(15)
                                .onTapGesture {
                                    grid2 = grid
                                }
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
