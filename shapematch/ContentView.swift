import SwiftUI
import AVFoundation

let deviceHeight = UIScreen.main.bounds.height
let deviceWidth = UIScreen.main.bounds.width
var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

struct ContentView: View {

    @ObservedObject private var appModel = AppModel.sharedAppModel
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
        ZStack{
            Color.white
                .ignoresSafeArea()
            Color.black.opacity(colorScheme == .dark ? 0.8 : 0.1)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                ButtonsView()
                Spacer()
                HStack{
                    Spacer()
                    VStack{
                        Text("🕹️")
                            .bold()
                            .font(.system(size: deviceWidth/12))
                            .fixedSize()
                            .customTextStroke(width: 1.8)
                        Text("Level")
                            .bold()
                            .font(.system(size: deviceWidth/12))
                            .fixedSize()
                            .customTextStroke(width: 1.5)
                        Text("\(userPersistedData.level)")
                            .bold()
                            .font(.system(size: deviceWidth/5))
                            .minimumScaleFactor(0.1)
                            .fixedSize()
                            .scaleEffect(userPersistedData.level > 999 ? 0.5 : userPersistedData.level > 99 ? 0.6 : 1)
                            .customTextStroke(width: 2.7)
                    }
                    .frame(width: deviceWidth/4)
                    .scaleEffect(idiom == .pad ? 0.8 : 1)
                    Spacer()
                    VStack{
                        Text("Goal 🎯")
                            .bold()
                            .font(.system(size: deviceWidth/15))
                            .fixedSize()
                            .customTextStroke(width: 1.8)
                        VStack{
                            ForEach(0..<appModel.grid.count, id: \.self) { row in
                                HStack {
                                    ForEach(0..<appModel.grid.count, id: \.self) { column in
                                        smallShapeView(shapeType: appModel.targetGrid[row][column])
                                            .frame(width: deviceWidth / ((CGFloat(appModel.grid.count) - 1.5) * 11), height: deviceWidth / ((CGFloat(appModel.grid.count) - 1.5) * 11))
                                            .padding(idiom == .pad ? 9 : 3)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.yellow)
                    .cornerRadius(15)
                    .overlay{
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black, lineWidth: 6)
                            .padding(1)
                    }
                    .pulsingPlaque()
                    .scaleEffect(idiom == .pad ? 0.8 : 1)
                    
                    Spacer()
                    VStack{
                        Text("↕️ ↔️")
                            .bold()
                            .font(.system(size: deviceWidth/12))
                            .fixedSize()
                            .customTextStroke(width: 1.8)
                        Text("Swaps")
                            .bold()
                            .multilineTextAlignment(.center)
                            .font(.system(size: deviceWidth/15))
                            .fixedSize()
                            .customTextStroke(width: 1.5)
                        Text("\(appModel.swipesLeft > 0 ? appModel.swipesLeft : 0)")
                            .bold()
                            .font(.system(size: deviceWidth/5))
                            .customTextStroke(width: 2.7)
                    }
                    .frame(width: deviceWidth/4)
                    .scaleEffect(idiom == .pad ? 0.8 : 1)
                    Spacer()
                    
                }
                
                Spacer()
                VStack {
                    ForEach(0..<appModel.grid.count, id: \.self) { row in
                        HStack {
                            ForEach(0..<appModel.grid.count, id: \.self) { column in
                                LargeShapeView(shapeType: appModel.grid[row][column])
                                    .frame(width: deviceWidth / ((CGFloat(appModel.grid.count) - 1.5) * 3), height: deviceWidth / ((CGFloat(appModel.grid.count) - 1.5) * 3))
                                    .padding(idiom == .pad ? 30 : 15)
                                    .background(.white.opacity(0.001))
                                    .offset(appModel.offsets[row][column])
                                    .scaleEffect((tappedRow == row && tappedColumn == column) ? playingShapeScale : 1)
                                    .animation(.easeInOut(duration: 0.1), value: playingShapeScale)
                                    .gesture(
                                        DragGesture(minimumDistance: 1)
                                            .onChanged { gesture in
                                                if !firstChange {
                                                    impactLight.impactOccurred()
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
            }
            .allowsHitTesting(!appModel.freezeGame)
            .scaleEffect(idiom == .pad ? 0.93 : 1)
            OverlaysView()
        }
        .onAppear {
            appModel.initialGrid = appModel.grid
            self.notificationManager.registerLocal()
            // 1054, 1109, 1054, 1057, 1114, 1115, 1159, 1166, 1300, 1308, 1313, 1322, 1334
//            AudioServicesPlaySystemSound(1114)
        }
        .onChange(of: scenePhase) { newScenePhase in
            DispatchQueue.main.async { [self] in
                self.playingShapeScale = 1.0
            }
        }
        .onChange(of: appModel.grid) { newScenePhase in
            DispatchQueue.main.async { [self] in
                self.playingShapeScale = 1.0
            }
        }
    }
    
}

#Preview {
    ContentView()
}
