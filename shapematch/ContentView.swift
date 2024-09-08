import SwiftUI
import AVFoundation

let deviceHeight = UIScreen.main.bounds.height
let deviceWidth = UIScreen.main.bounds.width
var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

struct ContentView: View {

    @ObservedObject private var appModel = AppModel.sharedAppModel
    @StateObject var audioController = AudioManager.sharedAudioManager
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    @State var firstChange = false
    @State var playingShapeScale = 1.0
    @State var tappedRow = 0
    @State var tappedColumn = 0
    
    let rect = CGRect(x: 0, y: 0, width: 300, height: 100)
    var body: some View {
        ZStack{
            Color.white
                .ignoresSafeArea()
            Color.gray.opacity(0.15)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                HStack{
                    Button {
                        appModel.showGemMenu = true
                    } label: {
                        HStack{
                            Spacer()
                            Text("💎")
                                .bold()
                                .italic()
                                .font(.system(size: deviceWidth/15))
                                .fixedSize()
                                .padding(.trailing, idiom == .pad ? 30: 9)
                                .customTextStroke(width: 1.8)
                                .scaleEffect(1.3)
                            Text("\(userPersistedData.gemBalance)")
                                .bold()
                                .italic()
                                .font(.system(size: deviceWidth/15))
                                .fixedSize()
                                .customTextStroke(width: 1.5)
                                .scaleEffect(1.5)
                            Spacer()
                                
                        }
                        .padding()
                        .background{
                            Color.blue
                        }
                        .cornerRadius(15)
                        .overlay{
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.black, lineWidth: 5)
                                .padding(1)
                        }
                        .padding(3)
                    }
                    .buttonStyle(.roundedAndShadow6)
                    
                    
                    
                    Button {
                        appModel.resetLevel()
                    } label: {
                        HStack{
                            Spacer()
                            Text("🔄")
                                .customTextStroke(width: 1.2)
                                .font(.system(size: deviceWidth/15))
                            Spacer()
                                
                        }
                        .padding()
                        .background{
                            Color.red
                        }
                        .cornerRadius(15)
                        .overlay{
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.black, lineWidth: 5)
                                .padding(1)
                        }
                        .padding(3)
                    }
                    .buttonStyle(.roundedAndShadow6)
                    
                    Button{
                        audioController.mute.toggle()
                    } label: {
                        HStack{
                            Spacer()
                            Text(audioController.mute ? "🔇" : "🔊")
                                .bold()
                                .italic()
                                .customTextStroke(width: 1.2)
                                .font(.system(size: deviceWidth/15))
                            Spacer()
                                
                        }
                        .padding()
                        .background{
                            Color.green
                        }
                        .cornerRadius(15)
                        .overlay{
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.black, lineWidth: 5)
                                .padding(1)
                        }
                        .padding(3)
                    }
                    .buttonStyle(.roundedAndShadow6)
                    .onChange(of: audioController.mute) { newSetting in
                        audioController.setAllAudioVolume()
                    }
                }
                .padding(.horizontal, 9)
//                .padding(.leading, 3)
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
                            .scaleEffect(userPersistedData.level > 99 ? 0.7 : 1)
                            .customTextStroke(width: 2.7)
                    }
                    .frame(width: deviceWidth/4)
                    Spacer()
                    VStack{
                        Text("Goal 🎯")
                            .bold()
                            .font(.system(size: deviceWidth/15))
                            .fixedSize()
                            .customTextStroke(width: 1.8)
                        VStack{
                            ForEach(0..<3) { row in
                                HStack {
                                    ForEach(0..<3) { column in
                                        smallShapeView(shapeType: appModel.targetGrid[row][column])
                                            .frame(width: deviceWidth / 15, height: deviceWidth / 15)
                                            .padding(3)
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
                        Text("\(appModel.swipesLeft)")
                            .bold()
                            .font(.system(size: deviceWidth/5))
                            .customTextStroke(width: 2.7)
                    }
                    .frame(width: deviceWidth/4)
                    Spacer()
                    
                }
                Spacer()
                VStack {
                    ForEach(0..<3) { row in
                        HStack {
                            ForEach(0..<3) { column in
                                LargeShapeView(shapeType: appModel.grid[row][column])
                                    .frame(width: deviceWidth / 4.5, height: deviceWidth / 4.5)
                                    .padding()
                                    .background(.white.opacity(0.01))
                                    .offset(appModel.offsets[row][column])
                                    .scaleEffect((tappedRow == row && tappedColumn == column) ? playingShapeScale : 1)
                                    .animation(.easeInOut(duration: 0.1), value: playingShapeScale)
                                    .gesture(
                                        DragGesture(minimumDistance: 1)
                                            .onChanged { gesture in
                                                if !firstChange {
                                                    impactHeavy.impactOccurred()
                                                    tappedRow = row
                                                    tappedColumn = column
                                                    withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10.0, initialVelocity: 0.0)) {
                                                        playingShapeScale = 0.8
                                                    }
                                                }
                                                firstChange = true
                                            }
                                            .onEnded { gesture in
                                                if appModel.swipesLeft > 0 {
                                                    appModel.handleSwipeGesture(gesture: gesture, row: row, col: column)
                                                }
                                                firstChange = false
                                                withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10.0, initialVelocity: 0.0)) {
                                                    playingShapeScale = 1.1
                                                }
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                                                    withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10.0, initialVelocity: 0.0)) {
                                                        playingShapeScale = 1.0
                                                    }
                                                }
                                            }
                                    )
                            }
                        }
                    }
                }
            }
            .allowsHitTesting(!appModel.freezeGame)
            .scaleEffect(idiom == .pad ? 0.9 : 1)
            OverlaysView()
        }
        
        .onAppear {
            appModel.initialGrid = appModel.grid
        }
    }
    
    func HoleShapeMask(in rect: CGRect) -> Path {
        var shape = Rectangle().path(in: rect)
        shape.addPath(Circle().path(in: rect))
        return shape
    }
    
}

#Preview {
    ContentView()
}
