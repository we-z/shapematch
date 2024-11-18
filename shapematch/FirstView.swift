//
//  FirstView.swift
//  Shape Shuffle
//
//  Created by Wheezy Capowdis on 11/17/24.
//

import SwiftUI

struct FirstView: View {
    @State var firstChange = false
    @State var playingShapeScale = 1.0
    @State var tappedRow = 0
    @State var tappedColumn = 0
    @Environment(\.scenePhase) var scenePhase
    
    let grid: [[ShapeType]] = [
        [.triangle, .triangle, .triangle],
        [.circle, .square, .circle],
        [.square, .circle, .square]
    ]
    
    var body: some View {
        
        ZStack{
            RadialGradient(
                gradient: Gradient(colors: [.white, .blue, .black]),
                center: UnitPoint.center,
                startRadius: 0,
                endRadius: deviceWidth
            )
            RotatingSunView()
                .frame(width: 1, height: 1)
                .scaleEffect(1.2)
            ZStack{
                
                VStack {
                    ForEach(0..<grid.count, id: \.self) { row in
                        HStack {
                            ForEach(0..<grid.count, id: \.self) { column in
                                ShapesView(shapeType: grid[row][column], skinType: "shapes")
                                    .frame(width: deviceWidth / 4.0, height: deviceWidth / 4.0)
                                    .scaleEffect(1.1)
                                    .scaleEffect(idiom == .pad ? 0.54 : 1)

                            }
                        }
                    }
                }
                .scaleEffect(idiom == .pad ? 1.2 : 1)
            }
            .frame(width: deviceWidth)
                
        }
        .ignoresSafeArea()
    }
}

#Preview {
    FirstView()
}
