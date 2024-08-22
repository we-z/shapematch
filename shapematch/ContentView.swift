import SwiftUI
import AVFoundation

let deviceHeight = UIScreen.main.bounds.height
let deviceWidth = UIScreen.main.bounds.width

struct ContentView: View {

    @ObservedObject private var appModel = AppModel.sharedAppModel
    @StateObject var audioController = AudioManager.sharedAudioManager
    @State private var hasSwiped = false
    
    let rect = CGRect(x: 0, y: 0, width: 300, height: 100)
    var body: some View {
        ZStack{
            Color.white
                .ignoresSafeArea()
            VStack(spacing: 0) {
                HStack{
                    Button {
                        
                    } label: {
                        HStack{
                            Spacer()
                            Text("💎")
                                .bold()
                                .italic()
                                .font(.system(size: deviceWidth/15))
                                .fixedSize()
                                .customTextStroke(width: 1.2)
                            Text("0")
                                .bold()
                                .italic()
                                .font(.system(size: deviceWidth/15))
                                .fixedSize()
                                .customTextStroke(width: 1.2)
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
                        .padding(6)
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
                        .padding(6)
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
                        .padding(6)
                    }
                    .buttonStyle(.roundedAndShadow6)
                    .onChange(of: audioController.mute) { newSetting in
                        audioController.setAllAudioVolume()
                    }
                }
                .padding(.leading, 6)
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
                            .customTextStroke(width: 1.8)
                        Text("\(appModel.level)")
                            .bold()
                            .font(.system(size: deviceWidth/5))
                            .customTextStroke(width: 3)
                    }
                    Spacer()
                    VStack{
                        Text("Goal 🎯")
                            .bold()
                            .font(.system(size: deviceWidth/15))
                            .fixedSize()
                            .customTextStroke(width: 1.2)
                        VStack{
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
                    }
                    .padding()
                    .background(Color.yellow)
                    .cornerRadius(15)
                    .overlay{
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black, lineWidth: 6)
                            .padding(1)
                    }
                    Spacer()
                    VStack{
                        Text("↔️")
                            .bold()
                            .font(.system(size: deviceWidth/12))
                            .fixedSize()
                            .customTextStroke(width: 1.8)
                        Text("Swaps")
                            .bold()
                            .multilineTextAlignment(.center)
                            .font(.system(size: deviceWidth/15))
                            .fixedSize()
                            .customTextStroke(width: 1.8)
                        Text("\(appModel.swipesLeft)")
                            .bold()
                            .font(.system(size: deviceWidth/5))
                            .customTextStroke(width: 3)
                    }
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
                                    .offset(appModel.offsets[row][column])
                                    .gesture(
                                        DragGesture()
                                            .onChanged { gesture in
                                                if appModel.swipesLeft > 0 && !hasSwiped {
                                                    let threshold: CGFloat = deviceWidth / 12 // Adjust threshold if needed
                                                    
                                                    if abs(gesture.translation.width) > threshold || abs(gesture.translation.height) > threshold {
                                                        appModel.handleSwipeGesture(gesture: gesture, row: row, col: column)
                                                        hasSwiped = true
                                                    }
                                                }
                                            }
                                            .onEnded { _ in
                                                hasSwiped = false // Reset after gesture ends
                                            }
                                    )
                            }
                        }
                    }
                }
            }
            .allowsHitTesting(!appModel.freezeGame)
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
