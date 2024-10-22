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
            TabView(selection: $appModel.selectedTab) {
                ZStack {
                    RotatingSunView()
                        .frame(width: 1, height: 1)
                        .offset(y: -(deviceHeight / 1.8))
                    LevelsView()
                }
                    .tag(0)
                ZStack{
                    LinearGradient(gradient: Gradient(colors: [.teal, .blue]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                        .ignoresSafeArea()
                    Group {
                        VStack(spacing: 0) {
                            Spacer()
                            if userPersistedData.level == 1 {
                                if idiom == .pad {
                                    Text("Line up\nthe shapes")
                                        .bold()
                                        .multilineTextAlignment(.center)
                                        .font(.system(size: deviceWidth/9))
                                        .customTextStroke(width: 3)
                                        .fixedSize()
                                } else {
                                    Text("Line up\nthe shapes")
                                        .bold()
                                        .multilineTextAlignment(.center)
                                        .font(.system(size: deviceWidth/6))
                                        .customTextStroke(width: 3)
                                        .fixedSize()
                                }
                            } else {
                                HStack {
                                    Spacer()
                                    Text("Level: \(userPersistedData.level)")
                                        .bold()
                                        .font(.system(size: deviceWidth/12))
                                        .customTextStroke(width: 1.8)
                                        .fixedSize()
                                    Spacer()
                                    if idiom == .pad {
                                        HStack {
                                            Text("Moves:")
                                                .bold()
                                                .font(.system(size: deviceWidth/12))
                                                .customTextStroke(width: 1.8)
                                                .fixedSize()
                                            Text(" \(appModel.swipesLeft)")
                                                .bold()
                                                .font(.system(size: deviceWidth/12))
                                                .customTextStroke(width: 1.8)
                                                .fixedSize()
                                        }
                                        Spacer()
                                    }
                                }
                                Spacer()
                                if idiom != .pad {
                                    Text("Moves:")
                                        .bold()
                                        .font(.system(size: deviceWidth/12))
                                        .customTextStroke(width: 1.8)
                                        .fixedSize()
                                
                                    Text("\(appModel.swipesLeft)")
                                        .bold()
                                        .italic()
                                        .font(.system(size: deviceWidth/4.2))
                                        .customTextStroke(width: 2.7)
                                        .fixedSize()
                                }
                            }
                            Spacer()
                            if userPersistedData.level != 1 {
                                ZStack{
                                    ButtonsView()
                                }
                                .padding(.vertical, idiom == .pad ? 21 : 3)
                                .zIndex(2)
                            }
                            ZStack{
                                Rectangle()
                                    .overlay{
                                        ZStack{
                                            Color.white
                                            Color.blue.opacity(0.6)
                                        }
                                    }
                                    .aspectRatio(1.0, contentMode: .fit)
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
                                                ShapeView(shapeType: appModel.grid[row][column])
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
                                            }
                                        }
                                    }
                                }
                                .scaleEffect(idiom == .pad ? 1.2 : 1)
                                if userPersistedData.level == 1 && !appModel.showLevelComplete && !appModel.showCelebration {
                                    HandSwipeView()
                                        .scaleEffect(idiom == .pad ? 0.8 : 1)
                                        .fixedSize()
//                                        .frame(width: 1, height: 1)
//                                        .zIndex(1)
                                        .offset(y: idiom == .pad ? deviceWidth / 4.1 : deviceWidth / 4.8)
                                }
                            }
                            .frame(width: deviceWidth)
                            .zIndex(1)
                        }
                        .allowsHitTesting(!appModel.freezeGame)
                    }
//                    .scaleEffect(idiom == .pad ? 0.75 : 1)
                }
                .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea()
            if appModel.showCelebration {
                CelebrationEffect()
            }
            if appModel.showNewLevelAnimation {
                NewLevelAnimation()
            }
            if appModel.showLevelComplete {
                LevelCompleteView()
            }
            if appModel.showNoMoreSwipesView {
                NoMoreSwipesView()
            }
            if appModel.showGemMenu {
                GemMenuView()
                    .padding(.bottom, idiom == .pad ? 60 : 0)
            }
            CelebrateGems()
            if appModel.showMovesCard {
                MovesView()
                    .padding(.bottom, idiom == .pad ? 150 : 0)
            }
            if appModel.showSettings {
                SettingsView()
                    .padding(.bottom, idiom == .pad ? 150 : 0)
            }
        }
//        .ignoresSafeArea()
//        .indexViewStyle(.never)
        .onAppear {
            appModel.initialGrid = appModel.grid
            self.notificationManager.registerLocal()
//            appModel.showMovesCard = true
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
