import SwiftUI
import AVFoundation

let deviceHeight = UIScreen.main.bounds.height
let deviceWidth = UIScreen.main.bounds.width

struct ContentView: View {

    @ObservedObject private var appModel = AppModel.sharedAppModel
    @StateObject var audioController = AudioManager.sharedAudioManager
    
    var body: some View {
        ZStack{
            Color.white
                .ignoresSafeArea()
            VStack {
                HStack{
                    Button {
                        
                    } label: {
                        HStack{
                            Text("💎 0")
                                .bold()
                                .italic()
                                .customTextStroke()
                                .font(.system(size: deviceWidth/11))
                                
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .frame(height: deviceWidth/6)
                        .background{
                            Color.blue
                        }
                        .cornerRadius(15)
                        .overlay{
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.black, lineWidth: 4)
                                .padding(1)
                        }
                        .fixedSize()
                        .padding(.leading)
                        
                    }
                    .buttonStyle(.roundedAndShadow6)
                    .padding(.leading, 6)
                    Spacer()
                    Button{
                        audioController.mute.toggle()
                    } label: {
                        Image(systemName: audioController.mute ? "speaker.slash.fill" : "speaker.wave.2.fill") // Replace with your image
                            .resizable()
                            .scaledToFit()
                            .frame(width:  deviceWidth/7, height:  deviceWidth/7)
                            .foregroundColor(.white)
                            .customTextStroke(width: 1.8 )
                            .padding(.horizontal)
                            .offset(y:1)
                    }
                    .buttonStyle(.roundedAndShadow3)
                    .onChange(of: audioController.mute) { newSetting in
                        audioController.setAllAudioVolume()
                    }
                    Spacer()
                    Button {
                        appModel.resetLevel()
                    } label: {
                        HStack{
                            Image(systemName: "arrow.counterclockwise")
                                .bold()
                                .italic()
                                .customTextStroke(width: 1.5)
                                .font(.system(size: deviceWidth/18))
                                .padding(.horizontal)
                        }
                        .padding(.horizontal, 21)
                        .padding(.vertical, 6)
                        .frame(height: deviceWidth/6.3)
                        .background{
                            Color.red
                        }
                        .cornerRadius(15)
                        .overlay{
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.black, lineWidth: 4)
                                .padding(1)
                        }
                        .padding(.trailing)
                    }
                    .buttonStyle(.roundedAndShadow6)
                }
                .padding(.top)
                Spacer()
                ZStack{
                    Text("Level : \(appModel.level)")
                        .bold()
                        .font(.system(size: deviceWidth/6))
                        .customTextStroke(width: 3)
                        .padding()
                }
                
                HStack{
                    Spacer()
                    VStack{
                        Text("🎯")
                            .bold()
                            .font(.system(size: deviceWidth/15))
                            .customTextStroke(width: 1.5)
                            .scaleEffect(1.5)
                            .offset(y:-3)
                        ForEach(0..<3) { row in
                            HStack {
                                ForEach(0..<3) { column in
                                    smallShapeView(shapeType: appModel.targetGrid[row][column])
                                        .frame(width: deviceWidth / 18, height: deviceWidth / 18)
                                        .padding(3)
                                }
                            }
                        }
                    }
                    .padding()
                    .frame(width: deviceWidth / 2.7)
                    .background(.yellow)
                    .cornerRadius(15)
                    .overlay{
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black, lineWidth: 4)
                            .padding(1)
                    }
                    
                    Spacer()
                    VStack{
                        Text("⬅️ ⬆️ ⬇️ ➡️")
                            .multilineTextAlignment(.center)
                            .bold()
                            .font(.system(size: deviceWidth/18))
                            .customTextStroke(width: 1.2)
                        Text("\(appModel.swipesLeft)")
                            .bold()
                            .font(.system(size: deviceWidth/4))
                            .customTextStroke(width: 2.4)
                            .fixedSize()
                    }
                    .padding()
                    .frame(width: deviceWidth / 2.7)
                    .background(Color.green)
                    .cornerRadius(15)
                    .overlay{
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black, lineWidth: 4)
                            .padding(1)
                    }
                    Spacer()
                }
                .padding(.bottom)
                ForEach(0..<3) { row in
                    HStack {
                        ForEach(0..<3) { column in
                            LargeShapeView(shapeType: appModel.grid[row][column])
                                .frame(width: deviceWidth / 4.5, height: deviceWidth / 4.5)
                                .padding()
                                .offset(appModel.offsets[row][column])
                                .gesture(
                                    DragGesture()
                                        .onChanged { gesture in
                                            // No change needed here for offset handling
                                        }
                                        .onEnded { gesture in
                                            if appModel.swipesLeft > 0 {
                                                appModel.handleSwipeGesture(gesture: gesture, row: row, col: column)
                                            }
                                        }
                                )
                        }
                    }
                }
//                Spacer()
            }
            .allowsHitTesting(!appModel.freezeGame)
            if appModel.showLevelDoneView || appModel.showNoMoreSwipesView {
                Color.gray.opacity(0.7)
                    .ignoresSafeArea()
            }
            VStack{
                Spacer()
                if appModel.showNoMoreSwipesView {
                    NoMoreSwipesView()
                }
                if appModel.showLevelDoneView {
                    LevelDoneView()
                }
            }
            CelebrationEffect()
            
        }
        .onAppear {
            appModel.initialGrid = appModel.grid
        }
    }
    
    
}

#Preview {
    ContentView()
}
