import SwiftUI
import AVFoundation

let deviceHeight = UIScreen.main.bounds.height
let deviceWidth = UIScreen.main.bounds.width

struct ContentView: View {

    @ObservedObject private var appModel = AppModel.sharedAppModel
    
    var body: some View {
        ZStack{
            Color.white
                .ignoresSafeArea()
            VStack {
                HStack{
                    Button {
                        
                    } label: {
                        HStack{
                            Text("💙 Lives: 1")
                                .bold()
                                .italic()
                                .customTextStroke(width: 1.5)
                                .font(.system(size: 21))
                        }
                        .padding(.horizontal, 21)
                        .padding(.vertical, 6)
                        .frame(height: 60)
                        .background{
                            Color.blue
                        }
                        .cornerRadius(15)
                        .overlay{
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.black, lineWidth: 4)
                                .padding(1)
                        }
                        .padding(.leading)
                    }
                    .buttonStyle(.roundedAndShadow6)
                    .padding(.leading, 6)
                    Spacer()
                    Button {
                        appModel.resetLevel()
                    } label: {
                        HStack{
                            Image(systemName: "arrow.counterclockwise")
                                .bold()
                                .italic()
                                .customTextStroke(width: 1.5)
                                .font(.system(size: 21))
                                .padding(.horizontal, 6)
                        }
                        .padding(.horizontal, 21)
                        .padding(.vertical, 6)
                        .frame(height: 60)
                        .background{
                            Color.red
                        }
                        .cornerRadius(15)
                        .overlay{
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.black, lineWidth: 4)
                                .padding(1)
                        }
                        .padding([.trailing, .leading])
                    }
                    .buttonStyle(.roundedAndShadow6)
                }
                Spacer()
                Text("Level: \(appModel.level)")
                    .bold()
                    .font(.system(size: deviceWidth/9))
                    .customTextStroke()
                
                HStack{
                    Spacer()
                    VStack{
                        Text("Goal 🎯")
                            .bold()
                            .font(.system(size: deviceWidth/15))
                            .customTextStroke(width: 1.5)
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
                    .background(.yellow)
                    .cornerRadius(15)
                    .overlay{
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black, lineWidth: 4)
                            .padding(1)
                    }
                    Spacer()
                    VStack{
                        Text("Swipes ↔️")
                            .multilineTextAlignment(.center)
                            .bold()
                            .font(.system(size: deviceWidth/18))
                            .customTextStroke(width: 1.2)
                        Text("\(appModel.swipesLeft)")
                            .bold()
                            .font(.system(size: deviceWidth/4))
                            .customTextStroke(width: 2.4)
                    }
                    .padding()
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
                                        .onChanged { _ in
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
                Spacer()
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
