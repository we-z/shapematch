//
//  GameView.swift
//  Shape Swap
//
//  Created by Wheezy Capowdis on 11/9/24.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var appModel = AppModel.sharedAppModel
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    @State var firstChange = false
    @State var playingShapeScale = 1.0
    @State var tappedRow = 0
    @State var tappedColumn = 0
    @Environment(\.scenePhase) var scenePhase
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                .ignoresSafeArea()
            VStack {
                Group {
                    VStack(spacing: 0) {
                        ZStack{
                            ButtonsView()
                        }
                        .padding(.vertical, idiom == .pad ? 21 : 3)
                        Spacer()
                        HStack {
                            Button {
                                if userPersistedData.hapticsOn {
                                    impactLight.impactOccurred()
                                }
                                withAnimation {
                                    appModel.showSkinsMenu = true
                                }
                            } label: {
                                Text("🛍️")
                                    .bold()
                                    .font(.system(size: idiom == .pad ? deviceWidth / 21 : deviceWidth / 12))
                                    .customTextStroke()
                                    .fixedSize()
                            }
                            Spacer()
                            Text("Level: \(userPersistedData.level)")
                                .bold()
                                .font(.system(size: idiom == .pad ? deviceWidth / 15 : deviceWidth/12))
                                .customTextStroke(width: 2.1)
                                .fixedSize()
                            Spacer()
                            if idiom == .pad {
                                HStack {
                                    Text("Moves: \(appModel.swipesLeft)")
                                        .bold()
                                        .font(.system(size: idiom == .pad ? deviceWidth / 15 : deviceWidth/12))
                                        .customTextStroke(width: 2.1)
                                        .fixedSize()
                                }
                                Spacer()
                            }
                            Button {
                                if userPersistedData.hapticsOn {
                                    impactLight.impactOccurred()
                                }
                                appModel.showMovesCard = true
                            } label: {
                                Text("🙋‍♂️")
                                    .bold()
                                    .font(.system(size: idiom == .pad ? deviceWidth / 21 : deviceWidth / 12))
                                    .customTextStroke()
                                    .fixedSize()
                            }
                        }
                        .padding(.horizontal, idiom == .pad ? 30 : 21)
                        Spacer()
                        if idiom != .pad {
                            Text("Moves:")
                                .bold()
                                .font(.system(size: deviceWidth/12))
                                .customTextStroke(width: 2.1)
                                .fixedSize()
                            
                            Text("\(appModel.swipesLeft)")
                                .bold()
                                .italic()
                                .font(.system(size: deviceWidth/4.2))
                                .customTextStroke(width: 2.7)
                                .fixedSize()
                        }
                        Spacer()
                        
                        
                    }
                }
                .zIndex(1)
                .opacity(userPersistedData.level == 1 ? 0 : 1)
                ZStack{
                    Rectangle()
                        .overlay{
                            ZStack{
                                Color.white
                                Color.blue.opacity(0.75)
                            }
                        }
                        .aspectRatio(1.0, contentMode: .fill)
                        .cornerRadius(30)
                        .overlay {
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.yellow, lineWidth: idiom == .pad ? 15 : 9)
                                .padding(1)
                                .shadow(color: .blue, radius: 6)
                        }
                        .shadow(color: .blue, radius: 6)
                        .padding()
                        .padding(idiom == .pad ? 30 : 0)
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
                    .scaleEffect(idiom == .pad ? 1.1 : 1)
                    if userPersistedData.level == 1 && !appModel.showLevelComplete && !appModel.showCelebration {
                        HandSwipeView()
                            .fixedSize()
                            .offset(y: idiom == .pad ? deviceWidth / 4.4 : deviceWidth / 4.8)
                    }
                }
                .frame(width: deviceWidth)
                .zIndex(0)
//                .scaleEffect(0.8)
                
            }
            .allowsHitTesting(!appModel.freezeGame)
            if userPersistedData.level == 1 {
                Text("Line up\nthe shapes")
                    .bold()
                    .multilineTextAlignment(.center)
                    .font(.system(size: idiom == .pad ? deviceWidth/9 : deviceWidth/6))
                    .customTextStroke(width: 3)
                    .fixedSize()
                    .offset(y: -(deviceWidth / 2))
            }
            CelebrateLineup()
        }
        .onChange(of: scenePhase) { newScenePhase in
            DispatchQueue.main.async { [self] in
                self.playingShapeScale = 1.0
            }
        }
    }
}

#Preview {
    GameView()
}
