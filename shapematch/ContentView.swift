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
    @State var shapeWidth = 0.0
    @State var shapeScale = 1.0
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack{
            Color.white
                .ignoresSafeArea()
            Color.black.opacity(colorScheme == .dark ? 0.8 : 0)
                .ignoresSafeArea()
            BackgroundView()
                .opacity(0.1)
            Group {
                VStack(spacing: 0) {
                    HStack{
//                        Spacer()
                        VStack{
                            Button {
                                appModel.showGemMenu = true
                            } label: {
                                HStack{
                                    Spacer()
                                    Text("💎 \(userPersistedData.gemBalance)")
                                        .bold()
                                        .font(.system(size: userPersistedData.gemBalance > 99 ?  deviceWidth/21 : deviceWidth/15))
                                        .lineLimit(1)
                                        .customTextStroke(width: 1.5)
                                        .fixedSize()
                                    Spacer()
                                    
                                }
                                .frame(height: idiom == .pad ? deviceWidth/9 : deviceWidth/7)
                                .background{
                                    LinearGradient(gradient: Gradient(colors: [.teal, .blue]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                                }
                                .cornerRadius(18)
                                .overlay{
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 5)
                                        .padding(1)
                                }
                                .padding(3)
                                
                            }
                            .buttonStyle(.roundedAndShadow6)
                            Spacer()
//                            Text("🕹️ 👾")
//                                .bold()
//                                .font(.system(size: deviceWidth/18))
//                                .fixedSize()
//                                .customTextStroke(width: 1.2)
//                                .padding(.top, idiom == .pad ? 60 : 0)
                            Text("Level")
                                .bold()
                                .font(.system(size: deviceWidth/15))
                                .fixedSize()
                                .customTextStroke(width: 1.5)
                            Text("\(userPersistedData.level)")
                                .bold()
                                .font(.system(size: userPersistedData.level  > 99 ? deviceWidth/8 : deviceWidth/6))
                                .minimumScaleFactor(0.1)
                                .fixedSize()
                                .customTextStroke()
                            Spacer()
                        }
                        .frame(width: deviceWidth/4)
//                        .scaleEffect(idiom == .pad ? 0.8 : 1)
                        Spacer()
                        VStack {
                            Spacer()
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
                                                    .frame(width: shapeWidth / 3.9, height: shapeWidth / 3.9)
                                                    .scaleEffect(shapeScale / 3.3)
                                                    .scaleEffect(idiom == .pad ? 0.5 : 1)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding( idiom == .pad ? 30 : 18)
                            .background{
                                if colorScheme == .dark {
                                    Color.black
                                    Color.white.opacity(0.3)
                                } else {
                                    Color.white
                                    Color.black.opacity(0.1)
                                }
                            }
                            .cornerRadius(idiom == .pad ? 30 : 15)
                            .overlay {
                                RoundedRectangle(cornerRadius: idiom == .pad ? 30 : 15)
                                    .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 4)
                                    .padding(1)
                            }
                            .pulsingPlaque()
//                            .scaleEffect(idiom == .pad ? 0.8 : 1)
                            Spacer()
                        }
                        Spacer()
                        VStack{
                            Button{
                                audioController.mute.toggle()
                            } label: {
                                HStack{
                                    Spacer()
                                    Text(audioController.mute ? "🔇" : "🔊")
                                        .bold()
                                        .italic()
                                        .customTextStroke(width: 1.2)
                                        .fixedSize()
                                        .font(.system(size: deviceWidth/21))
                                        .scaleEffect(idiom == .pad ? 1 : 1.2)
                                    Spacer()
                                    
                                }
                                .frame(height: idiom == .pad ? deviceWidth/9 : deviceWidth/7)
                                .background{
                                    LinearGradient(gradient: Gradient(colors: [.purple, .indigo]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                                }
                                .cornerRadius(18)
                                .overlay{
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 5)
                                        .padding(1)
                                }
                                .padding(3)
                            }
                            .buttonStyle(.roundedAndShadow6)
                            Spacer()
//                            Text("↔️ ↕️")
//                                .bold()
//                                .multilineTextAlignment(.center)
//                                .font(.system(size: deviceWidth/18))
//                                .fixedSize()
//                                .customTextStroke(width: 1.5)
//                                .padding(.top, idiom == .pad ? 60 : 0)
                            Text("Moves")
                                .bold()
                                .multilineTextAlignment(.center)
                                .font(.system(size: deviceWidth/15))
                                .fixedSize()
                                .customTextStroke(width: 1.5)
                            Text("\(appModel.swipesLeft > 0 ? appModel.swipesLeft : 0)")
                                .bold()
                                .font(.system(size: deviceWidth/6))
                                .customTextStroke()
                            
                            Spacer()
                        }
                        .frame(width: deviceWidth/4)
//                        .scaleEffect(idiom == .pad ? 0.8 : 1)
//                        Spacer()
                        
                    }
                    .padding(.horizontal)
                    ZStack{
                        ButtonsView()
                        //                            .padding(.horizontal, idiom == .pad ? 69 : 21)
//                        if !userPersistedData.firstGamePlayed {
                            InstructionView()
                                .frame(height: 1)
//                        }
//                        if userPersistedData.level < 4 {
//                            NewGoalView()
//                                .frame(height: 1)
//                        }
                    }
                    .padding(.vertical, idiom == .pad ? 41 : 3)
                    .zIndex(1)
//                    .scaleEffect(0.9)
//                    VStack {
//                        ForEach(0..<appModel.grid.count, id: \.self) { row in
//                            HStack {
//                                ForEach(0..<appModel.grid.count, id: \.self) { column in
//                                    ShapeView(shapeType: appModel.grid[row][column])
//                                        .frame(width: deviceWidth / ((CGFloat(appModel.grid.count) - 1.27) * 2.7), height: deviceWidth / ((CGFloat(appModel.grid.count) - 1.27) * 2.7))
//                                        .scaleEffect(2.2 - (CGFloat(appModel.grid.count) * 0.36))
//                                        .padding(idiom == .pad ? 30 : 15)
//                                        .background(.white.opacity(0.001))
//                                        .offset(appModel.offsets[row][column])
//                                        .scaleEffect((tappedRow == row && tappedColumn == column) ? playingShapeScale : 1)
//                                        .animation(.easeInOut(duration: 0.1), value: playingShapeScale)
//                                        .gesture(
//                                            DragGesture(minimumDistance: 1)
//                                                .onChanged { gesture in
//                                                    if !firstChange {
//                                                        impactLight.impactOccurred()
//                                                        tappedRow = row
//                                                        tappedColumn = column
//                                                        DispatchQueue.main.async { [self] in
//                                                            withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10.0, initialVelocity: 0.0)) {
//                                                                self.playingShapeScale = 0.6
//                                                            }
//                                                        }
//                                                    }
//                                                    firstChange = true
//                                                }
//                                                .onEnded { gesture in
//                                                    DispatchQueue.main.async { [self] in
//                                                        withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10.0, initialVelocity: 0.0)) {
//                                                            self.playingShapeScale = 1.0
//                                                        }
//                                                    }
//                                                    if appModel.swipesLeft > 0 {
//                                                        appModel.handleSwipeGesture(gesture: gesture, row: row, col: column)
//                                                    }
//                                                    firstChange = false
//                                                }
//                                        )
//                                }
//                            }
//                        }
//                    }
//                    .background {
//                        ZStack {
//                            if colorScheme == .dark {
//                                Color.black
//                                Color.white.opacity(0.3)
//                            } else {
//                                Color.white
//                                Color.black.opacity(0.1)
//                            }
//                        }
//                        
//                        .cornerRadius(30)
//                        .scaleEffect(1.1)
//                    }
//                    .scaleEffect(0.9)
//                    .overlay {
//                        RoundedRectangle(cornerRadius: 30)
//                            .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 6)
//                            .padding(1)
//                    }
//                    .padding(.bottom, 21)
                    ZStack{
                        Rectangle()
                            .overlay{
                                if colorScheme == .dark {
                                    Color.black
                                    Color.white.opacity(0.3)
                                } else {
                                    Color.white
                                    Color.black.opacity(0.1)
                                }
                            }
                            .aspectRatio(1.0, contentMode: .fill)
                            .cornerRadius(30)
                            .overlay {
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 6)
                                    .padding(1)
                            }
                            .padding()
                        VStack {
                            ForEach(0..<appModel.grid.count, id: \.self) { row in
                                HStack {
                                    ForEach(0..<appModel.grid.count, id: \.self) { column in
                                        ShapeView(shapeType: appModel.grid[row][column])
                                            .frame(width: shapeWidth, height: shapeWidth)
                                            .scaleEffect(shapeScale)
                                            .scaleEffect(idiom == .pad ? 0.54 : 1)
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
                        .scaleEffect(idiom == .pad ? 1.1 : 1)
                    }
                }
                .allowsHitTesting(!appModel.freezeGame)
                OverlaysView()
            }
            .scaleEffect(idiom == .pad ? 0.8 : 1)
            CelebrationEffect()
            if appModel.showGemMenu {
                GemMenuView()
            } else if appModel.showNoMoreSwipesView {
                NoMoreSwipesView()
            }
            CelebrateGems()
        }
        .onAppear {
            appModel.initialGrid = appModel.grid
            self.notificationManager.registerLocal()
            
            if appModel.grid.count == 3 {
                shapeWidth = deviceWidth / 4.0
                shapeScale = deviceWidth / 390
            } else if appModel.grid.count == 4 {
                shapeWidth = deviceWidth / 5.3
                shapeScale = deviceWidth / 540
            } else if appModel.grid.count == 5 {
                shapeWidth = deviceWidth / 6.6
                shapeScale = deviceWidth / 690
            }
            
            // 1054, 1109, 1054, 1057, 1114, 1115, 1159, 1166, 1300, 1308, 1313, 1322, 1334
//            AudioServicesPlaySystemSound(1105)
        }
        .onChange(of: appModel.grid) { newScenePhase in
            DispatchQueue.main.async { [self] in
                self.playingShapeScale = 1.0
            }
            if appModel.grid.count == 3 {
                shapeWidth = deviceWidth / 4.0
                shapeScale = deviceWidth / 390
            } else if appModel.grid.count == 4 {
                shapeWidth = deviceWidth / 5.3
                shapeScale = deviceWidth / 540
            } else if appModel.grid.count == 5 {
                shapeWidth = deviceWidth / 6.6
                shapeScale = deviceWidth / 690
            }
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
