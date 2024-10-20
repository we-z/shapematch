//
//  LevelsView.swift
//  Shape Swap
//
//  Created by Wheezy Capowdis on 9/30/24.
//

import SwiftUI
import Vortex

struct LevelsView: View {
    @State var dissapear = false
    @ObservedObject var appModel = AppModel.sharedAppModel
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    @State private var currentLevel = 1
    @State var chosenLevel = 1
    @State var moves = 1
    @State var shapeWidth = 0.0
    @State var shapeScale = 1.0
    @State var shapes: [ShapeType] = [] {
        didSet {
            appModel.winningGrids = appModel.generateAllWinningGrids(shapes: shapes)
        }
    }
    @State private var scrollProxy: ScrollViewProxy? = nil
    @State var showLevelDetails = false
    @Environment(\.colorScheme) var colorScheme
    let emojis = ["🐟", "🐠", "🐡", "🦈", "🐬", "🐳", "🐋", "🐙", "🦑", "🦀", "🦞", "🦐", "🐚", "🪸", "🐊", "🌊", "🏄‍♂️", "🏄‍♀️", "🚤", "⛵", "🏝️", "🏖️"]
    
    @State var previewGrid: [[ShapeType]] = [] {
        didSet {
            if previewGrid.count == 3 {
                shapeWidth = deviceWidth / 4.0
                shapeScale = deviceWidth / 390
            } else if previewGrid.count == 4 {
                shapeWidth = deviceWidth / 5.3
                shapeScale = deviceWidth / 540
            } else if previewGrid.count == 5 {
                shapeWidth = deviceWidth / 6.6
                shapeScale = deviceWidth / 690
            }
        }
    }
    
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
        system.lifespan = 15
        system.shape = .box(width: 9, height: 0)
        system.angle = .degrees(180)
        system.angleRange = .degrees(20)
        system.size = 0.1
        system.sizeVariation = 0.5
        return system
    }

    var body: some View {
        ZStack {
            ZStack {
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
                            .font(.system(size: idiom == .pad ? deviceWidth/8 : deviceWidth/4))
                            .blur(radius: 0)
                            .frame(width: 300, height: 300)
                            .rotationEffect(.degrees(180))
                            .tag(emojis[i])
                    }
                }
                .rotationEffect(.degrees(180))
                .opacity(0.3)
            }
            .ignoresSafeArea()

            VStack {
                
                // Top title displaying grid dimensions and shapes
                HomeButtonsView()
//              Text("Shape Swap!")
//                    .bold()
//                    .italic()
//                    .font(.system(size: deviceWidth / 9))
//                    .customTextStroke(width: 2.2)
//                    .padding(.top)
                // ScrollView with lazy loading
                ZStack {
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack {
                                ForEach(1...9999, id: \.self) { level in
                                        
                                        LevelRow(level: level)
                                                .id(level)
                                                .padding(.top, level == 1 ? deviceHeight / 21 : 0)
                                                .opacity( level <= userPersistedData.highestLevel ? 1.0 : 0.4)
                                                .offset(x: sin(CGFloat(level) * .pi / 6) * (idiom == .pad ? deviceWidth / 4.5 : deviceWidth / 3.6))
                                                .onTapGesture{
                                                    if level == 1 {
                                                        withAnimation {
                                                            userPersistedData.level = 1
                                                            appModel.setupFirstLevel()
                                                            appModel.selectedTab = 1
                                                        }
                                                    } else {
                                                        chosenLevel = level
                                                        (moves, shapes) = appModel.determineLevelSettings(level: chosenLevel)
                                                        previewGrid = appModel.generateTargetGrid(from: shapes, with: moves)
                                                        showLevelDetails = true
                                                    }
                                                    if userPersistedData.hapticsOn {
                                                        impactLight.impactOccurred()
                                                    }
                                                }
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
                            }
                        }
                        .frame(width: deviceWidth)
                    }
                }
//                .frame(width: .infinity)
            }
            if showLevelDetails {
                LevelDetailsView
            }
        }
    }
    
    func animateAwayButtonsAndBanner() {
        DispatchQueue.main.async { [self] in
            withAnimation(.linear(duration: 0.3)) {
                cardOffset = deviceWidth * 3
            }
        }
    }
    
    var LevelDetailsView: some View {
        ZStack{
            Color.gray.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    DispatchQueue.main.async { [self] in
                        withAnimation(.interpolatingSpring(mass: 6.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                            cardOffset = deviceWidth * 3
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                                if userPersistedData.hapticsOn {
                                    impactLight.impactOccurred()
                                }
                                showLevelDetails = false
                            }
                        }
                    }
                }
                .gesture(
                    DragGesture()
                        .onEnded { gesture in
                            if gesture.translation.height > 0 {
                                DispatchQueue.main.async { [self] in
                                    withAnimation(.interpolatingSpring(mass: 6.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                                        cardOffset = deviceWidth * 3
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                                            if userPersistedData.hapticsOn {
                                                impactLight.impactOccurred()
                                            }
                                            showLevelDetails = false
                                        }
                                    }
                                }
                            }
                        }
                )
            VStack{
                Spacer()
                ZStack {
                    VStack(spacing: 0){
                        Capsule()
                            .overlay {
                                ZStack{
                                    Color.blue
                                }
                            }
                            .frame(width: 45, height: 9)
                            .cornerRadius(15)
                            .padding(.bottom, 15)
                            .customTextStroke()
                        Text("Level: \(chosenLevel)")
                            .bold()
                            .font(.system(size: deviceWidth/15))
                            .fixedSize()
                            .customTextStroke(width: 1.5)
                        Text("Moves: \(moves + 2)")
                            .bold()
                            .multilineTextAlignment(.center)
                            .font(.system(size: deviceWidth/15))
                            .fixedSize()
                            .customTextStroke(width: 1.5)
                            .padding()
                            VStack{
                                VStack{
                                    ForEach(0..<shapes.count, id: \.self) { row in
                                        HStack {
                                            ForEach(0..<shapes.count, id: \.self) { column in
                                                ShapeView(shapeType: previewGrid[row][column])
                                                    .frame(width: shapeWidth / 1.2, height: shapeWidth / 1.2)
                                                    .scaleEffect( shapeScale / 1.2)
                                                    .scaleEffect(idiom == .pad ? 0.5 : 1)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding( idiom == .pad ? 30 : 18)
                            .background{
                                ZStack{
                                    Color.white
                                    Color.blue.opacity(0.6)
                                }
                            }
                            .cornerRadius(idiom == .pad ? 30 : 18)
                            .overlay {
                                RoundedRectangle(cornerRadius: idiom == .pad ? 30 : 18)
                                    .stroke(Color.yellow, lineWidth: idiom == .pad ? 9 : 7)
                                    .padding(1)
                                    .shadow(radius: 3)
                            }
                            .shadow(radius: 3)
                        .padding(.vertical)
                        if chosenLevel <= userPersistedData.highestLevel {
                            Button {
                                animateAwayButtonsAndBanner()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                                    userPersistedData.level = chosenLevel
                                    appModel.setupLevel(startGrid: previewGrid)
                                    withAnimation {
                                        appModel.selectedTab = 1
                                        showLevelDetails = false
                                    }
                                }
                            } label: {
                                HStack{
                                    Spacer()
                                    Text("Play!  ➡️")
                                        .italic()
                                        .bold()
                                        .font(.system(size: deviceWidth/12))
                                        .fixedSize()
                                        .customTextStroke(width: 2.1)
                                    Spacer()
                                }
                                .padding()
                                .background{
                                    LinearGradient(gradient: Gradient(colors: [.mint, .green]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 0.3))
                                }
                                .cornerRadius(21)
                                .overlay{
                                    RoundedRectangle(cornerRadius: 21)
                                        .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 5)
                                        .padding(1)
                                }
                                .padding()
                                
                            }
                            .buttonStyle(.roundedAndShadow6)
                        }
                    }
                }
                .padding()
                .background{
                    LinearGradient(gradient: Gradient(colors: [.orange, .red]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                }
                .cornerRadius(30)
                .overlay{
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.black, lineWidth: 9)
                        .padding(1)
                }
                .padding()
                .scaleEffect(idiom == .pad ? 0.6 : 1)
                .offset(y: cardOffset)
                .onAppear{
                    DispatchQueue.main.async {
                        cardOffset = deviceHeight
                        withAnimation(.interpolatingSpring(mass: 6.0, stiffness: 100.0, damping: 30.0, initialVelocity: 0.0)) {
                            cardOffset = 0
                        }
                    }
                }
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            cardOffset = gesture.translation.height
                        }
                        .onEnded { gesture in
                            if gesture.translation.height > 0 {
                                DispatchQueue.main.async { [self] in
                                    withAnimation(.interpolatingSpring(mass: 6.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                                        cardOffset = deviceWidth * 3
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                                            if userPersistedData.hapticsOn {
                                                impactLight.impactOccurred()
                                            }
                                            showLevelDetails = false
                                        }
                                    }
                                }
                            } else {
                                DispatchQueue.main.async { [self] in
                                    withAnimation(.interpolatingSpring(mass: 6.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                                        cardOffset = 0
                                    }
                                }
                            }
                        }
                )
            }
        }
    }
}

// LevelRow to display individual level information
struct LevelRow: View {
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    var level: Int

    var body: some View {
        VStack {
            ZStack {
                if level == userPersistedData.highestLevel {
                    RotatingSunView()
                        .frame(width: 1, height: 1)
                        .foregroundColor(.white)
                        .scaleEffect(0.3)
                }
                Circle()
                    .frame(width: idiom == .pad ? deviceWidth / 18 : deviceWidth / 7)
                    .overlay{
                        LinearGradient(gradient: Gradient(colors: [.orange, .red]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                            .mask(Circle())
                    }
                    .customTextStroke(width: idiom == .pad ? 1.8 : 3)
                Text("\(level)")
                    .bold()
                    .font(.system(size: idiom == .pad ? deviceWidth / 33 : deviceWidth / 12 ))
                    .scaleEffect(level > 999 ? 0.5 : level > 99 ? 0.78 : 1)
                    .fixedSize()
                    .customTextStroke(width: idiom == .pad ? 1.2 : 1.8)
                
            }
            
            HStack {
                if level <= userPersistedData.highestLevel {
                    Text("⭐️")
                        .offset(y: -12)
                        .rotationEffect(.degrees(21))
                    Text("⭐️")
                        .opacity(userPersistedData.levelStars[String(level)] ?? 1 > 1 ? 1 : 0.3)
                    Text("⭐️")
                        .offset(y: -12)
                        .rotationEffect(.degrees(-21))
                        .opacity(userPersistedData.levelStars[String(level)] ?? 1 > 2 ? 1 : 0.3)
                }
            }
            .customTextStroke(width:1)
            .offset(y: idiom == .pad ? -1 : -3)
            .font(.system(size: idiom == .pad ? deviceWidth / 60 : deviceWidth / 21))
            .frame(height: idiom == .pad ? deviceWidth / 36 : deviceWidth / 27)
        }
        
    }
}

#Preview {
    LevelsView()
}
