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
            TabView(selection: $userPersistedData.selectedTab) {
                ZStack {
                    RotatingSunView()
                        .frame(width: 1, height: 1)
                        .offset(y: -(deviceHeight / 1.8))
                    LevelsView()
                }
                    .tag(0)
                ZStack{
                    //            Color.white
                    //                .ignoresSafeArea()
                    //            Color.black.opacity(colorScheme == .dark ? 0.8 : 0.3)
                    //                .ignoresSafeArea()
                    //            BackgroundView()
                    //                .opacity(userPersistedData.level == 1 ? 0.0 : 0.2)
                    //            Color.blue
                    //                .ignoresSafeArea()
                    Group {
                        VStack(spacing: 0) {
                            ZStack{
                                GameButtonsView()
                                    .opacity((userPersistedData.level != 1) ? 1 : 0)
                            }
                            .padding(.vertical, idiom == .pad ? 41 : 3)
                            .zIndex(2)
                            HStack{
                                VStack{
                                    Spacer()
                                    VStack {
                                        Text("Level")
                                            .bold()
                                            .font(.system(size: deviceWidth/15))
                                            .fixedSize()
                                            .customTextStroke(width: 1.8)
                                        Text("\(userPersistedData.level)")
                                            .bold()
                                            .font(.system(size: userPersistedData.level  > 99 ? deviceWidth/8 : deviceWidth/6))
                                            .minimumScaleFactor(0.1)
                                            .fixedSize()
                                            .customTextStroke()
                                    }
                                    Spacer()
                                }
                                .frame(width: deviceWidth/4)
                                .opacity((userPersistedData.level != 1) ? 1 : 0)
                                Spacer()
                                VStack {
                                    Spacer()
                                    VStack{
                                        Text("Match")
                                            .bold()
                                            .font(.system(size: deviceWidth/15))
                                            .fixedSize()
                                            .customTextStroke(width: 1.8)
                                        VStack{
                                            ForEach(0..<appModel.grid.count, id: \.self) { row in
                                                HStack {
                                                    ForEach(0..<appModel.grid.count, id: \.self) { column in
                                                        ShapeView(shapeType: appModel.targetGrid[row][column])
                                                            .frame(width: appModel.shapeWidth / 3.9, height: appModel.shapeWidth / 3.9)
                                                            .scaleEffect(appModel.shapeScale / 3.3)
                                                            .scaleEffect(idiom == .pad ? 0.5 : 1)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .padding( idiom == .pad ? 30 : 18)
                                    .background{
                                        //                                if colorScheme == .dark {
                                        //                                    Color.black
                                        //                                    Color.white.opacity(0.36)
                                        //                                } else {
                                        //                                    Color.white
                                        //                                    Color.black.opacity(0.15)
                                        //                                }
                                        //                                LinearGradient(gradient: Gradient(colors: [.purple, .purple]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                                        ZStack{
                                            Color.white
                                            Color.blue.opacity(0.6)
                                        }
                                    }
                                    .cornerRadius(idiom == .pad ? 30 : 15)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: idiom == .pad ? 30 : 15)
                                            .stroke(Color.yellow, lineWidth: idiom == .pad ? 9 : 4)
                                            .padding(1)
                                            .shadow(radius: 3)
                                    }
                                    .shadow(radius: 3)
                                    .onTapGesture {
                                        if userPersistedData.level != 1 {
                                            appModel.showInstruction.toggle()
                                        }
                                    }
                                    .pulsingPlaque(speed: 1.2, size: userPersistedData.level == 1 ? 1.5 : 2.7)
                                    //                            .scaleEffect(idiom == .pad ? 0.8 : 1)
                                    Spacer()
                                }
                                .zIndex(1)
                                Spacer()
                                VStack{
                                    Spacer()
                                    VStack{
                                        Text("Moves")
                                            .bold()
                                            .multilineTextAlignment(.center)
                                            .font(.system(size: deviceWidth/15))
                                            .fixedSize()
                                            .customTextStroke(width: 1.8)
                                        Text("\(appModel.swipesLeft > 0 ? appModel.swipesLeft : 0)")
                                            .bold()
                                            .font(.system(size: userPersistedData.level  > 99 ? deviceWidth/8 : deviceWidth/6))
                                            .customTextStroke()
                                    }
                                    Spacer()
                                }
                                .frame(width: deviceWidth/4)
                                .opacity((userPersistedData.level != 1) ? 1 : 0)
                                
                            }
                            .padding(.horizontal)
                            .zIndex(3)
                            //                    .zIndex(1)
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
                                            .stroke(Color.yellow, lineWidth: idiom == .pad ? 11 : 6)
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
                                .scaleEffect(idiom == .pad ? 1.1 : 1)
                            }
                            .zIndex(1)
                        }
                        .allowsHitTesting(!appModel.freezeGame)
                        OverlaysView()
                    }
                    .scaleEffect(idiom == .pad ? 0.75 : 1)
                }
                .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea()
            CelebrationEffect()
            if appModel.showGemMenu {
                GemMenuView()
                    .padding(.bottom, idiom == .pad ? 60 : 0)
            } else if appModel.showNoMoreSwipesView {
                NoMoreSwipesView()
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
