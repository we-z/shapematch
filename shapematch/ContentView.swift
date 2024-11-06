import SwiftUI
import AVFoundation

let deviceHeight = UIScreen.main.bounds.height
let deviceWidth = UIScreen.main.bounds.width
var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

struct ContentView: View {

    @ObservedObject var appModel = AppModel.sharedAppModel
    @StateObject var audioController = AudioManager.sharedAudioManager
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    @ObservedObject var notificationManager = NotificationManager()
    @State var firstChange = false
    @State var playingShapeScale = 1.0
    @State var tappedRow = 0
    @State var tappedColumn = 0
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.teal, .blue]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                .ignoresSafeArea()
                ZStack {
                    RotatingSunView()
                        .frame(width: 1, height: 1)
                        .offset(y: -(deviceHeight / 1.8))
                    LevelsView()
                }
                ZStack{
                    LinearGradient(gradient: Gradient(colors: [.teal, .blue]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
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
                                    Text("🙋‍♂️")
                                        .bold()
                                        .font(.system(size: deviceWidth / 12))
                                        .customTextStroke()
                                        .fixedSize()
                                        .padding(.leading)
                                        .opacity(0)
                                    Spacer()
                                    Text("Level: \(userPersistedData.level)")
                                        .bold()
                                        .font(.system(size: deviceWidth/12))
                                        .customTextStroke(width: 2.1)
                                        .fixedSize()
                                    Spacer()
                                    if idiom == .pad {
                                        HStack {
                                            Text("Moves:")
                                                .bold()
                                                .font(.system(size: deviceWidth/12))
                                                .customTextStroke(width: 2.1)
                                                .fixedSize()
                                            Text(" \(appModel.swipesLeft)")
                                                .bold()
                                                .font(.system(size: deviceWidth/12))
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
                                            .font(.system(size: deviceWidth / 12))
                                            .customTextStroke()
                                            .fixedSize()
                                            .padding(.trailing)
                                    }
                                }
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
                                            Color.blue.opacity(0.6)
                                        }
                                    }
                                    .aspectRatio(1.0, contentMode: .fill)
                                    .cornerRadius(30)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 30)
                                            .stroke(Color.yellow, lineWidth: idiom == .pad ? 11 : 7)
                                            .padding(1)
                                            .shadow(radius: 3)
                                    }
                                    .shadow(radius: 3)
                                    .padding()
                                VStack {
                                    ForEach(0..<appModel.grid.count, id: \.self) { row in
                                        HStack {
                                            ForEach(0..<appModel.grid.count, id: \.self) { column in
                                                ShapesView(shapeType: appModel.grid[row][column], skinType: userPersistedData.chosenSkin)
                                                    .frame(width: appModel.shapeWidth, height: appModel.shapeWidth)
                                                    .scaleEffect(appModel.shapeScale)
                                                    .scaleEffect(idiom == .pad ? 0.54 : 1)
                                                    .background(.white.opacity(0.001))
                                                    .offset(appModel.offsets[row][column])
                                                    .scaleEffect((tappedRow == row && tappedColumn == column) ? playingShapeScale : 1)
                                                    .animation(.easeInOut(duration: 0.1), value: playingShapeScale)
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
//                                                    .onReceive(appModel.timer) { _ in
//                                                        if userPersistedData.level == 2 {
//                                                            if !appModel.setupSwaps.isEmpty {
//                                                                let lastSwap = appModel.setupSwaps.last!
//                                                                appModel.hintSwapShapes(start: (row: lastSwap.0.row, col: lastSwap.0.col), end: (row: lastSwap.1.row, col: lastSwap.1.col))
//                                                            }
//                                                        }
//                                                    }
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
//                            .scaleEffect(0.8)
                        
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
                }
                .offset(x: appModel.selectedTab == 1 ? 0 : deviceWidth)
            if appModel.showCelebration {
                CelebrationEffect()
            }
            if appModel.showNewLevelAnimation {
                NewLevelAnimation()
            }
            if appModel.showLevelComplete {
                LevelCompleteView()
            }
            if appModel.showLevelDetails {
                LevelPreviewCard()
            }
            if appModel.showNoMoreSwipesView {
                NoMoreSwipesView()
            }
            if appModel.showGemMenu {
                GemMenuView()
            }
            CelebrateGems()
            if appModel.showMovesCard {
                MovesView()
            }
            if appModel.showSettings {
                SettingsView()
            }
            SkinsMenuView()
                .offset(x: appModel.showSkinsMenu ? 0 : deviceWidth)

        }
        .onAppear {
            appModel.initialGrid = appModel.grid
            self.notificationManager.registerLocal()
            // 1054, 1109, 1054, 1057, 1114, 1115, 1159, 1166, 1300, 1308, 1313, 1322, 1334
//            AudioServicesPlaySystemSound(1105)
        }
        .onChange(of: scenePhase) { newScenePhase in
            DispatchQueue.main.async { [self] in
                self.playingShapeScale = 1.0
            }
        }

    }
    
}

#Preview {
    ContentView()
}
