//
//  iconview.swift
//  Shape Swap
//
//  Created by Wheezy Capowdis on 9/2/24.
//

import SwiftUI

struct iconview: View {
    @ObservedObject var appModel = AppModel.sharedAppModel
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    @State var firstChange = false
    @State var playingShapeScale = 1.0
    @State var tappedRow = 0
    @State var tappedColumn = 0
    @Environment(\.scenePhase) var scenePhase
    var body: some View {
        ZStack{
//            LinearGradient(gradient: Gradient(colors: [.teal, .blue, .purple]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
//                .frame(height: deviceWidth)
            RadialGradient(
                gradient: Gradient(colors: [.white, .blue, .black]),
                center: UnitPoint.center,
                startRadius: 0,
                endRadius: 330
            )
            .frame(height: deviceWidth)
            RotatingSunView()
                .frame(width: 1, height: 1)
            ZStack{
//                Rectangle()
//                    .overlay{
//                        ZStack{
//                            Color.white
//                            Color.blue.opacity(0.6)
//                        }
//                    }
//                    .aspectRatio(1.0, contentMode: .fit)
//                    .cornerRadius(30)
//                    .overlay {
//                        RoundedRectangle(cornerRadius: 30)
//                            .stroke(Color.yellow, lineWidth: idiom == .pad ? 11 : 9)
//                            .padding(1)
//                            .shadow(radius: 3)
//                    }
//                    .shadow(radius: 3)
//                    .padding()
                
                VStack {
                    ForEach(0..<appModel.grid.count, id: \.self) { row in
                        HStack {
                            ForEach(0..<appModel.grid.count, id: \.self) { column in
                                ShapesView(shapeType: appModel.grid[row][column], skinType: userPersistedData.chosenSkin)
                                    .frame(width: appModel.shapeWidth, height: appModel.shapeWidth)
                                    .scaleEffect(appModel.shapeScale)
                                    .scaleEffect(idiom == .pad ? 0.54 : 1)
                                    .scaleEffect((tappedRow == row && tappedColumn == column) ? playingShapeScale : 1)
                                    .offset(appModel.offsets[row][column])
                                    .background(Color.white.opacity(0.001))
                                    .gesture(
                                        DragGesture(minimumDistance: 1)
                                            .onChanged { gesture in
                                                if !firstChange {
                                                    if userPersistedData.hapticsOn {
                                                        impactLight.impactOccurred()
                                                    }
                                                    tappedRow = row
                                                    tappedColumn = column
                                                    DispatchQueue.main.async { [self] in
                                                        withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10.0, initialVelocity: 0.0)) {
                                                            self.playingShapeScale = 0.6
                                                        }
                                                    }
                                                }
                                                firstChange = true
                                            }
                                            .onEnded { gesture in
                                                DispatchQueue.main.async { [self] in
                                                    withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10.0, initialVelocity: 0.0)) {
                                                        self.playingShapeScale = 1.0
                                                    }
                                                }
                                                if appModel.swipesLeft > 0 {
                                                    appModel.handleSwipeGesture(gesture: gesture, row: row, col: column)
                                                }
                                                firstChange = false
                                            }
                                    )
                                    .animation(.easeInOut(duration: 0.1), value: playingShapeScale)

                            }
                        }
                    }
                }
                .scaleEffect(idiom == .pad ? 1.2 : 1)
                if userPersistedData.level == 1 && !appModel.showLevelComplete && !appModel.showCelebration {
                    HandSwipeView()
                        .fixedSize()
                        .offset(y: idiom == .pad ? deviceWidth / 4.4 : deviceWidth / 4.8)
                }
            }
            .frame(width: deviceWidth)
            .zIndex(0)
            .scaleEffect(0.85)
                
        }
        .onChange(of: scenePhase) { newScenePhase in
            DispatchQueue.main.async { [self] in
                self.playingShapeScale = 1.0
            }
        }
    }
}

#Preview {
    iconview()
}
