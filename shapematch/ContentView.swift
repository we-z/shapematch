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
                            Text("💎 0")
                                .bold()
                                .italic()
                                .font(.system(size: deviceWidth/15))
                                .minimumScaleFactor(0.5)
                                .fixedSize()
                                .customTextStroke()
                            Spacer()
                                
                        }
                        .padding()
                        .background{
                            Color.blue
                        }
                        .cornerRadius(15)
                        .overlay{
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.black, lineWidth: 4)
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
                                .customTextStroke()
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
                                .stroke(Color.black, lineWidth: 4)
                                .padding(1)
                        }
                        .padding(6)
                    }
                    .buttonStyle(.roundedAndShadow6)
                    .onChange(of: audioController.mute) { newSetting in
                        audioController.setAllAudioVolume()
                    }
                    
                    Button {
                        appModel.resetLevel()
                    } label: {
                        HStack{
                            Spacer()
                            Text("🔄")
                                .bold()
                                .italic()
                                .customTextStroke()
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
                                .stroke(Color.black, lineWidth: 4)
                                .padding(1)
                        }
                        .padding(6)
                    }
                    .buttonStyle(.roundedAndShadow6)
                }
                .padding(.leading, 6)
                Spacer()
                Text("Level : \(appModel.level)")
                    .bold()
                    .font(.system(size: deviceWidth/6))
                    .customTextStroke(width: 3)
                Spacer()
                HStack{
                    Spacer()
                    
                    HStack{
                        Text("⬆️\n➡️\n⬅️\n⬇️")
                            .multilineTextAlignment(.center)
                            .font(.system(size: deviceWidth/21))
                            .fixedSize()
                        Spacer()
                        Text("\(appModel.swipesLeft)")
                            .bold()
                            .font(.system(size: deviceWidth/4))
                            .customTextStroke(width: 2.4)
                            .fixedSize()
                        Spacer()
                    }
                    .padding()
                    .frame(width: deviceWidth / 2.4, height: deviceWidth / 3.3)
                    .background(Color.green)
                    .cornerRadius(15)
                    .overlay{
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black, lineWidth: 6)
                            .padding(1)
                    }
                    Spacer()
                    
                    HStack{
                        Text("🎯")
                            .bold()
                            .font(.system(size: deviceWidth/15))
                            .scaleEffect(1.5)
                            .fixedSize()
                            .offset(y: -6)
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
                    .frame(width: deviceWidth / 2.4, height: deviceWidth / 3.3)
                    .background(.yellow)
                    .cornerRadius(15)
                    .overlay{
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black, lineWidth: 6)
                            .padding(1)
                    }
                    
                    
                    Spacer()
                    
                }
                Spacer()
//                .frame(height: deviceHeight/7)
//                .scaleEffect(0.6)
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
