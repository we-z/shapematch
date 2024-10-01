//
//  LevelsView.swift
//  Shape Swap
//
//  Created by Wheezy Capowdis on 9/30/24.
//

import SwiftUI

struct LevelsView: View {
    @ObservedObject var appModel = AppModel.sharedAppModel
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    @State private var currentLevel = 1
    @State private var scrollProxy: ScrollViewProxy? = nil

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.mint, .green]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                .ignoresSafeArea()
            VStack {
                // Top title displaying grid dimensions and shapes
                Text("👾 Levels 🕹️")
                    .bold()
                    .font(.system(size: deviceWidth / 9))
                    .customTextStroke()
                    .padding()
                HStack {
                    VStack(spacing: 3){
                        HStack {
                        Text("\(getGridSize(level: currentLevel))x\(getGridSize(level: currentLevel))")
                            .bold()
                            .font(.system(size: deviceWidth / 9))
                            .customTextStroke(width: 1.8)
                            Spacer()
                    }
                        HStack(spacing: 4) {
                            ForEach(getShapes(level: currentLevel), id: \.self) { shape in
                                ShapeView(shapeType: shape)
                                    .frame(width: deviceWidth / 9, height: deviceWidth / 9)
                                    .scaleEffect(0.5)
                            }
                            Spacer()
                        }
                    }
                    .padding(.leading)
                    Spacer()
                    Text("Moves:\n\(getSwapsNeeded(level: currentLevel))")
                        .bold()
                        .multilineTextAlignment(.center)
                        .font(.system(size: deviceWidth / 9))
                        .customTextStroke(width: 2.1)
                        .padding(.trailing)
                }
//                            .animation(.default, value: currentLevel)
                
                
                
                // Button to jump back to current level
                
                // ScrollView with lazy loading
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack {
                            ForEach(1...10000, id: \.self) { level in
                                LevelRow(level: level,
                                         isUnlocked: level <= userPersistedData.level,
                                         swapsNeeded: getSwapsNeeded(level: level))
                                .customTextStroke(width: 3)
//                                .onTapGesture {
//                                    if level <= userPersistedData.level {
//                                        appModel.userPersistedData.level = level
//                                        appModel.setupLevel()
//                                    }
//                                }
                                .id(level)
                                .padding(.top, level == 1 ? deviceHeight / 7 : 0)
                                .background(GeometryReader { geo -> Color in
                                    let frame = geo.frame(in: .global)
                                    let midY = UIScreen.main.bounds.height / 1.5
                                    let diff = abs(frame.midY - midY)
                                    DispatchQueue.main.async {
                                        if diff < 50 {
                                            self.currentLevel = level
                                        }
                                    }
                                    return Color.clear
                                })
                                .scaleEffect(currentLevel == level ? 1.0 : 0.6)
                                .opacity( level <= userPersistedData.level ? 1.0 : 0.4)
                                .animation(.default, value: currentLevel)
                            }
                        }
                    }
                    .onAppear {
                        self.scrollProxy = proxy
                        // Jump to the current level
                        DispatchQueue.main.async {
                            withAnimation {
                                proxy.scrollTo(userPersistedData.level, anchor: .center)
                            }
                            self.currentLevel = userPersistedData.level
                        }
                    }
                }
            }
            VStack {
                Spacer()
                HStack{
                    Spacer()
                    if currentLevel > userPersistedData.level {
                        Button(action: {
                            if let scrollProxy = scrollProxy {
                                withAnimation {
                                    scrollProxy.scrollTo(userPersistedData.level, anchor: .center)
                                }
                                self.currentLevel = userPersistedData.level
                            }
                            
                        }) {
                            Text("⬆️")
                                .font(.system(size: deviceWidth / 6))
                                .customTextStroke(width: 3)
                                .padding()
                        }
                        .padding()
                    }
                }
            }
        }
    }

    // Helper functions to get level settings
    func getLevelSettings(level: Int) -> (swapsNeeded: Int, shapes: [ShapeType], gridSize: Int) {
        var swapsNeeded = 1
        var shapes: [ShapeType] = []

        switch level {
        case 1...6:
            swapsNeeded = level
        case 7...10:
            swapsNeeded = 6
        case 11...15:
            swapsNeeded = 7
        case 16...27:
            swapsNeeded = 8
        case 28...39:
            swapsNeeded = 9
        case 40...70:
            swapsNeeded = 10
        case 71...100:
            swapsNeeded = 11
        case 101...150:
            swapsNeeded = 12
        case 151...200:
            swapsNeeded = 13
        case 201...300:
            swapsNeeded = 14
        case 301...499:
            swapsNeeded = 15
        case 500...750:
            swapsNeeded = 16
        case 751...999:
            swapsNeeded = 17
        case 1000...3000:
            swapsNeeded = 18
        case 3001...6000:
            swapsNeeded = 19
        case 6001...9999:
            swapsNeeded = 20
        default:
            swapsNeeded = 21
        }

        switch level {
        case 1...15:
            shapes = [.circle, .square, .triangle]
        case 16...499:
            shapes = [.circle, .square, .triangle, .star]
        default:
            shapes = [.circle, .square, .triangle, .star, .heart]
        }

        let gridSize = shapes.count
        return (swapsNeeded, shapes, gridSize)
    }

    func getSwapsNeeded(level: Int) -> Int {
        return getLevelSettings(level: level).swapsNeeded
    }

    func getShapes(level: Int) -> [ShapeType] {
        return getLevelSettings(level: level).shapes
    }

    func getGridSize(level: Int) -> Int {
        return getLevelSettings(level: level).gridSize
    }
}

// LevelRow to display individual level information
struct LevelRow: View {
    var level: Int
    var isUnlocked: Bool
    var swapsNeeded: Int

    var body: some View {
        ZStack {
            Circle()
                .frame(width: deviceWidth / 3)
                .overlay{
                    LinearGradient(gradient: Gradient(colors: [.orange, .red]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                        .mask(Circle())
                }
            Text("\(level)")
                .bold()
                .font(.system(size: deviceWidth / 5))
                .customTextStroke(width: 3)
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    LevelsView()
}
