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
    @State private var scrollProxy: ScrollViewProxy? = nil
    let emojis = ["🐟", "🐠", "🐡", "🦈", "🐬", "🐳", "🐋", "🐙", "🦑", "🦀", "🦞", "🦐", "🐚", "🪸"]
    
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
                
            ZStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack {
                            ForEach(1...9999, id: \.self) { level in
                                    
                                    LevelRow(level: level)
                                            .id(level)
                                            .padding(.top, level == 1 ? deviceHeight / 4 : 0)
                                            .opacity( level <= userPersistedData.highestLevel ? 1.0 : 0.4)
                                            .offset(x: sin(CGFloat(level) * .pi / 6) * (deviceWidth / 3))
                                            .onTapGesture{
                                                if level == 1 {
                                                    withAnimation {
                                                        userPersistedData.level = 1
                                                        appModel.setupFirstLevel()
                                                        appModel.selectedTab = 1
                                                    }
                                                } else {
                                                    appModel.previewLevel = level
                                                    (appModel.previewMoves, appModel.previewShapes) = appModel.determineLevelSettings(level: level)
                                                    appModel.previewGrid = appModel.generateTargetGrid(from: appModel.previewShapes, with: appModel.previewMoves)
                                                    appModel.showLevelDetails = true
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
                    .onChange(of: appModel.selectedTab) { selectedTab in
                        if selectedTab == 0 {
                            proxy.scrollTo(userPersistedData.level, anchor: .center)
                        }
                    }
                    .frame(width: deviceWidth)
                }
                VStack {
                    HomeButtonsView()
                    Spacer()
                    Button {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                            userPersistedData.level = userPersistedData.highestLevel
                            appModel.setupLevel()
                            withAnimation {
                                appModel.selectedTab = 1
                            }
                            appModel.showNewLevelAnimation = true
                        }
                    } label: {
                        HStack{
                            Spacer()
                            Text("Level \(userPersistedData.highestLevel)  ➡️")
                                .italic()
                                .bold()
                                .font(.system(size: deviceWidth/12))
                                .fixedSize()
                                .customTextStroke(width: 2.1)
                            Spacer()
                        }
                        .padding()
                        .background{
                            LinearGradient(gradient: Gradient(colors: [.mint, .green]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 0.5))
                        }
                        .cornerRadius(21)
                        .overlay{
                            RoundedRectangle(cornerRadius: 21)
                                .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 5)
                                .padding(1)
                        }
                        .padding(30)
                        .padding(idiom == .pad ? 30 : 0)
                        
                    }
                    .buttonStyle(.roundedAndShadow6)
                }
            }
        }
    }
}

// LevelRow to display individual level information
struct LevelRow: View {
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    var level: Int

    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    if level == userPersistedData.highestLevel {
                        RotatingSunView()
                            .frame(width: 1, height: 1)
                            .foregroundColor(.white)
                            .scaleEffect(0.3)
                    }
                    Circle()
                        .frame(width: idiom == .pad ? deviceWidth / 12 : deviceWidth / 7)
                        .overlay{
                            if userPersistedData.levelStars[String(level)] ?? 0 > 2 {
                                LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                                    .mask(Circle())
                            } else {
                                LinearGradient(gradient: Gradient(colors: [.orange, .red]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                                    .mask(Circle())
                            }
                        }
                        .customTextStroke(width: idiom == .pad ? 1.8 : 2.1)
                    Text("\(level)")
                        .bold()
                        .font(.system(size: idiom == .pad ? deviceWidth / 21 : deviceWidth / 13 ))
                        .scaleEffect(level > 999 ? 0.5 : level > 99 ? 0.78 : 1)
                        .fixedSize()
                        .customTextStroke(width: idiom == .pad ? 1.2 : 1.8)
                }
                
                HStack {
                    if level <= userPersistedData.highestLevel {
                        Text("⭐️")
                            .offset(y: -12)
                            .rotationEffect(.degrees(21))
                            .opacity(userPersistedData.levelStars[String(level)] ?? 0 > 0 ? 1 : 0.3)
                        Text("⭐️")
                            .opacity(userPersistedData.levelStars[String(level)] ?? 0 > 1 ? 1 : 0.3)
                        Text("⭐️")
                            .offset(y: -12)
                            .rotationEffect(.degrees(-21))
                            .opacity(userPersistedData.levelStars[String(level)] ?? 0 > 2 ? 1 : 0.3)
                    }
                }
                .customTextStroke(width:1)
                .offset(y: idiom == .pad ? -9 : -3)
                .font(.system(size: idiom == .pad ? deviceWidth / 33 : deviceWidth / 21))
                .frame(height: deviceWidth / 27)
            }
            if userPersistedData.levelStars[String(level)] ?? 0 > 2 {
                Text("💎")
                    .customTextStroke(width:1.2)
                    .font(.system(size: idiom == .pad ? deviceWidth / 33 : deviceWidth / 18))
                    .offset(x: idiom == .pad ? deviceWidth / 12 : deviceWidth / 8)
            }
        }
        .onAppear {
            if userPersistedData.hapticsOn {
                impactSoft.impactOccurred()
            }
        }
    }
}

#Preview {
    LevelsView()
}
