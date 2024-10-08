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
    @State var shapes: [ShapeType] = []
    @State private var scrollProxy: ScrollViewProxy? = nil
    @State var showLevelDetails = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    let emojis = ["🐟", "🐠", "🐡", "🦈", "🐬", "🐳", "🐋", "🐙", "🦑", "🦀", "🦞", "🦐", "🐚", "🪸", "🐊", "🌊", "🏄‍♂️", "🏄‍♀️", "🚤", "🛥️", "⛴️", "🛳️", "🚢", "⛵", "🏝️", "🏖️", "🪼"]
    
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
    
    @State var cardOffset: CGFloat = deviceWidth
    
    func shufflePreview() {
        previewGrid = []
        for _ in 0..<shapes.count {
            previewGrid.append(shapes.shuffled())
        }
    }
    
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
                Capsule()
                    .foregroundColor(.blue)
                    .frame(width: 45, height: 9)
                    .padding(.top, 15)
                    .customTextStroke()
                // Top title displaying grid dimensions and shapes
                Text("Levels")
//                    .italic()
                    .bold()
                    .font(.system(size: deviceWidth / 12))
                    .customTextStroke()
//                    .padding(.top, 30)
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
                                                        userPersistedData.level = chosenLevel
                                                        appModel.setupFirstLevel()
                                                        dismiss()
                                                    } else {
                                                        chosenLevel = level
                                                        (moves, shapes) = appModel.determineLevelSettings(level: chosenLevel)
                                                        shufflePreview()
                                                        showLevelDetails = true
                                                    }
                                                    impactLight.impactOccurred()
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
                cardOffset = deviceWidth
            }
        }
    }
    
    var LevelDetailsView: some View {
        ZStack{
            Color.gray.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    DispatchQueue.main.async { [self] in
                        withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                            cardOffset = deviceWidth * 2
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                                impactLight.impactOccurred()
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
                                    withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                                        cardOffset = deviceWidth * 2
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                                            impactLight.impactOccurred()
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
                            .foregroundColor(.blue)
                            .frame(width: 45, height: 9)
                            .padding(.bottom, 15)
                            .customTextStroke()
                        HStack{
                            Spacer()
                            VStack{
                                
                                VStack() {
                                    Text("Level")
                                        .bold()
                                        .font(.system(size: deviceWidth/15))
                                        .fixedSize()
                                        .customTextStroke(width: 1.5)
                                    Text("\(chosenLevel)")
                                        .bold()
                                        .font(.system(size: chosenLevel > 999 ? deviceWidth/12 : chosenLevel > 99 ? deviceWidth/9 : deviceWidth/6))
                                        .minimumScaleFactor(0.1)
                                        .fixedSize()
                                        .customTextStroke()
                                    
                                }
                            }
                            .frame(width: deviceWidth/5)
                            Spacer()
                            VStack {
                                VStack{
                                    VStack{
                                        ForEach(0..<shapes.count, id: \.self) { row in
                                            HStack {
                                                ForEach(0..<shapes.count, id: \.self) { column in
                                                    ShapeView(shapeType: previewGrid[row][column])
                                                        .frame(width: shapeWidth / 3.9, height: shapeWidth / 3.9)
                                                        .scaleEffect( shapeScale / 3.3)
                                                        .scaleEffect(idiom == .pad ? 0.5 : 1)
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding( idiom == .pad ? 30 : 18)
                                .background{
                                    LinearGradient(gradient: Gradient(colors: [.teal, .blue]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                                }
                                .cornerRadius(idiom == .pad ? 30 : 15)
                                .overlay {
                                    RoundedRectangle(cornerRadius: idiom == .pad ? 30 : 15)
                                        .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 5)
                                        .padding(1)
                                }
                                //                            .scaleEffect(idiom == .pad ? 0.8 : 1)
                            }
                            Spacer()
                            VStack{
                                Text("Moves")
                                    .bold()
                                    .multilineTextAlignment(.center)
                                    .font(.system(size: deviceWidth/15))
                                    .fixedSize()
                                    .customTextStroke(width: 1.5)
                                Text("\(moves)")
                                    .bold()
                                    .font(.system(size: chosenLevel > 999 ? deviceWidth/12 : chosenLevel > 99 ? deviceWidth/9 : deviceWidth/6))
                                    .customTextStroke()
                                
                            }
                            .frame(width: deviceWidth/5)
                            Spacer()
                        }
                        .padding(.vertical)
                        if chosenLevel <= userPersistedData.highestLevel {
                            Button {
                                userPersistedData.firstGamePlayed = true
                                animateAwayButtonsAndBanner()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                                    userPersistedData.level = chosenLevel
                                    appModel.setupLevel(startGrid: previewGrid)
                                    dismiss()
                                }
                            } label: {
                                HStack{
                                    Spacer()
                                    Text("Play!")
                                        .italic()
                                        .bold()
                                        .font(.system(size: deviceWidth/12))
                                        .fixedSize()
                                        .customTextStroke(width: 2.1)
                                    Spacer()
                                }
                                .padding()
                                .background{
                                    LinearGradient(gradient: Gradient(colors: [.teal, .blue]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
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
                        cardOffset = deviceWidth
                        withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
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
                                    withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                                        cardOffset = deviceWidth * 2
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                                            impactLight.impactOccurred()
                                            showLevelDetails = false
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
            }
        }
    }
}

// LevelRow to display individual level information
struct LevelRow: View {
    var level: Int

    var body: some View {
        ZStack {
            Circle()
                .frame(width: idiom == .pad ? deviceWidth / 10 : deviceWidth / 7)
                .overlay{
                    LinearGradient(gradient: Gradient(colors: [.orange, .red]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                        .mask(Circle())
                }
            Text("\(level)")
                .bold()
                .font(.system(size: level > 999 ? deviceWidth / 21 : level > 99 ? deviceWidth / 15 : deviceWidth / 12))
                .fixedSize()
                .scaleEffect(idiom == .pad ? 0.6 : 1)
                .customTextStroke(width: 1.8)
                
        }
        .customTextStroke(width: 3)
        
    }
}

#Preview {
    LevelsView()
}
