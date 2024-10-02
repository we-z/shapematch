//
//  LevelsView.swift
//  Shape Swap
//
//  Created by Wheezy Capowdis on 9/30/24.
//

import SwiftUI
import Vortex

struct LevelsView: View {
    @ObservedObject var appModel = AppModel.sharedAppModel
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    @State private var currentLevel = 1
    @State private var scrollProxy: ScrollViewProxy? = nil
    let emojis = ["🐟", "🐠", "🐡", "🦈", "🐬", "🐳", "🐋", "🐙", "🦑", "🦀", "🦞", "🦐", "🐚", "🪸", "🐊", "🌊", "🏄‍♂️", "🏄‍♀️", "🚤", "🛥️", "⛴️", "🛳️", "🚢", "⛵", "🏝️", "🏖️", "🪼"]
    
    @State var cardOffset: CGFloat = deviceHeight
    
    func createBubbles() -> VortexSystem {
        let system = VortexSystem(tags: ["circle"])
        system.position = [0.5, 0]
        system.speed = 0.1
        system.speedVariation = 0.25
        system.lifespan = 6
        system.shape = .box(width: 3, height: 0)
        system.angle = .degrees(180)
        system.angleRange = .degrees(20)
        system.size = 0.1
        system.sizeVariation = 0.5
        return system
    }
    
    func createEmojis() -> VortexSystem {
        let system = VortexSystem(tags: emojis)
        system.position = [0.5, 0]
        system.speed = 0.1
        system.speedVariation = 0.15
        system.lifespan = 9
        system.shape = .box(width: 9, height: 0)
        system.angle = .degrees(180)
        system.angleRange = .degrees(20)
        system.size = 0.1
        system.sizeVariation = 0.5
        return system
    }

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.teal, .blue]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
            RotatingSunView()
                .frame(width: 1, height: 1)
                .offset(y: -(deviceHeight / 2))
            VortexView(createBubbles()) {
                Circle()
                    .fill(.blue)
                    .blendMode(.plusLighter)
                    .blur(radius: 0)
                    .frame(width: 50)
                    .padding(90)
                    .tag("circle")
            }
            .rotationEffect(.degrees(180))
            VortexView(createEmojis()) {
                ForEach(0...emojis.count - 1, id: \.self) { i in
                    Text(emojis[i])
                        .font(.system(size: deviceWidth/4))
                        .blur(radius: 0)
                        .frame(width: .infinity, height: .infinity)
                        .rotationEffect(.degrees(180))
                        .tag(emojis[i])
                }
            }
            .rotationEffect(.degrees(180))
            .opacity(0.3)
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
//                                withAnimation {
                                    proxy.scrollTo(userPersistedData.level, anchor: .center)
//                                }
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
//                .background(.green)
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
        .offset(y: cardOffset)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    cardOffset = gesture.translation.height
                }
                .onEnded { gesture in
                    if gesture.translation.height > 0 {
                        DispatchQueue.main.async { [self] in
                            withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                                cardOffset = deviceHeight
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                                    impactLight.impactOccurred()
                                    appModel.showGemMenu = false
                                }
                            }
                        }
                    } else {
                        DispatchQueue.main.async { [self] in
                            withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                                cardOffset = 0
                            }
                        }
                    }
                }
        )
        .onAppear{
            DispatchQueue.main.async {
                withAnimation(.interpolatingSpring(mass: 2.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                    cardOffset = 0
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
