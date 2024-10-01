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
            LinearGradient(gradient: Gradient(colors: [.teal, .blue]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
            VStack {
                Capsule()
                    .foregroundColor(.blue)
                    .frame(width: 45, height: 9)
                    .padding(.top, 15)
                    .customTextStroke()
                // Top title displaying grid dimensions and shapes
                Text("Levels")
                    .bold()
                    .font(.system(size: deviceWidth / 8))
                    .customTextStroke()
                // ScrollView with lazy loading
                ZStack {
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack {
                                ForEach(1...10000, id: \.self) { level in
                                    LevelRow(level: level,
                                             isUnlocked: level <= userPersistedData.level,
                                             swapsNeeded: getSwapsNeeded(level: level))
                                    
                                    //                                .onTapGesture {
                                    //                                    if level <= userPersistedData.level {
                                    //                                        appModel.userPersistedData.level = level
                                    //                                        appModel.setupLevel()
                                    //                                    }
                                    //                                }
                                    .id(level)
                                    .padding(.top, level == 1 ? deviceHeight / 3 : 0)
                                    .background(GeometryReader { geo -> Color in
                                        let frame = geo.frame(in: .global)
                                        let midY = UIScreen.main.bounds.height / 1.8
                                        let diff = abs(frame.midY - midY)
                                        DispatchQueue.main.async {
                                            if diff < 50 {
                                                self.currentLevel = level
                                                impactLight.impactOccurred()
                                            }
                                        }
                                        return Color.clear
                                    })
                                    .rotationEffect(.degrees(currentLevel == level ? 0 : level % 2 == 0 ? 25 : -15 ))
                                    .scaleEffect(currentLevel == level ? 1.0 : 0.8)
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
                                        .font(.system(size: deviceWidth / 9))
                                        .customTextStroke()
                                        .padding()
                                }
                                .padding()
                            }
                        }
                    }
                }
                
                HStack {
                    VStack(spacing: 12){
                        HStack {
                        Text("\(getGridSize(level: currentLevel))x\(getGridSize(level: currentLevel))")
                            .bold()
                            .font(.system(size: deviceWidth / 12))
                            .customTextStroke(width: 1.8)
                            Spacer()
                    }
                        HStack(spacing: 4) {
                            ForEach(getShapes(level: currentLevel), id: \.self) { shape in
                                ShapeView(shapeType: shape)
                                    .frame(width: deviceWidth / 12, height: deviceWidth / 12)
                                    .scaleEffect(0.3)
                            }
                            Spacer()
                        }
                    }
                    .padding(.leading)
                    Spacer()
                    Text("Moves:\n\(getSwapsNeeded(level: currentLevel))")
                        .bold()
                        .multilineTextAlignment(.center)
                        .font(.system(size: deviceWidth / 11))
                        .customTextStroke(width: 1.8)
                        .padding(.trailing)
                }
                .padding(.bottom)
//                .animation(.default, value: currentLevel)
            }
        }
        .cornerRadius(30)
        .overlay{
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.black, lineWidth: 9)
                .padding(1)
        }
        .padding()
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
                .frame(width: deviceWidth / 5)
                .overlay{
                    LinearGradient(gradient: Gradient(colors: [.orange, .red]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                        .mask(Circle())
                }
            Text("\(level)")
                .bold()
                .font(.system(size: level > 99 ? deviceWidth / 12 : deviceWidth / 9))
                .customTextStroke()
                
        }
        .customTextStroke(width: 3)
        .offset(x: level % 2 == 0 ? deviceWidth / 7 : -(deviceWidth/7))
        
        
    }
}

#Preview {
    LevelsView()
}
