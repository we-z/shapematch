import SwiftUI

let deviceHeight = UIScreen.main.bounds.height
let deviceWidth = UIScreen.main.bounds.width

struct ContentView: View {
    @State private var grid: [[ShapeType]] = [
        [.circle, .circle, .circle],
        [.square, .triangle, .square],
        [.triangle, .square, .triangle]
    ]
    
    let targetGrid: [[ShapeType]] = [
        [.circle, .circle, .circle],
        [.square, .square, .square],
        [.triangle, .triangle, .triangle]
    ]
    
    @State private var offsets: [[CGSize]] = Array(
        repeating: Array(repeating: .zero, count: 3),
        count: 3
    )
    
    @State var showCelebration = false
    
    @State var swipesLeft = 1
    
    var body: some View {
        ZStack{
//            RandomGradientView()
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
                        .padding()
                    }
                    .buttonStyle(.roundedAndShadow6)
                    .padding(.leading, 6)
                    Spacer()
                    Button {
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
                Text("Level: 1")
                    .italic()
                    .bold()
                    .font(.system(size: deviceWidth/9))
                    .customTextStroke(width: 1.8)
                HStack{
                    Spacer()
                    VStack{
                        Text("Goal 🎯")
                            .italic()
                            .bold()
                            .font(.system(size: deviceWidth/15))
                            .customTextStroke(width: 1.5)
                        ForEach(0..<3) { row in
                            HStack {
                                ForEach(0..<3) { column in
                                    smallShapeView(shapeType: targetGrid[row][column])
                                        .frame(width: deviceWidth / 18, height: deviceWidth / 18)
                                        .padding(3)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(.yellow)
                    .cornerRadius(30)
                    .overlay{
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.black, lineWidth: 4)
                            .padding(1)
                    }
                    Spacer()
                    VStack{
                        Text("Swipes ↔️")
                            .multilineTextAlignment(.center)
                            .italic()
                            .bold()
                            .font(.system(size: deviceWidth/18))
                            .customTextStroke(width: 1.2)
                        Text("\(swipesLeft)")
                            .italic()
                            .bold()
                            .font(.system(size: deviceWidth/3))
                            .customTextStroke(width: 3)
                    }
                    Spacer()
                }
                .padding()
                ForEach(0..<3) { row in
                    HStack {
                        ForEach(0..<3) { column in
                            LargeShapeView(shapeType: grid[row][column])
                                .frame(width: deviceWidth / 4.5, height: deviceWidth / 4.5)
//                                .stroke(.black, lineWidth: 6)
                                .padding()
                                .offset(offsets[row][column])
                                .gesture(
                                    DragGesture()
                                        .onChanged { _ in
                                            // No change needed here for offset handling
                                        }
                                        .onEnded { gesture in
                                            handleSwipeGesture(gesture: gesture, row: row, col: column)
                                            swipesLeft -= 1
                                            impactHeavy.impactOccurred()
                                        }
                                )
                        }
                    }
                }
            }
            if self.showCelebration {
                CelebrationEffect()
            }
        }
    }
    
    func handleSwipeGesture(gesture: DragGesture.Value, row: Int, col: Int) {
        let direction: SwipeDirection
        
        if abs(gesture.translation.width) > abs(gesture.translation.height) {
            direction = gesture.translation.width < 0 ? .left : .right
        } else {
            direction = gesture.translation.height < 0 ? .up : .down
        }
        
        switch direction {
        case .left where col > 0:
            swapShapes(start: (row, col), end: (row, col - 1), offset: CGSize(width: -deviceWidth / 3, height: 0))
        case .right where col < 2:
            swapShapes(start: (row, col), end: (row, col + 1), offset: CGSize(width: deviceWidth / 3, height: 0))
        case .up where row > 0:
            swapShapes(start: (row, col), end: (row - 1, col), offset: CGSize(width: 0, height: -deviceWidth / 3))
        case .down where row < 2:
            swapShapes(start: (row, col), end: (row + 1, col), offset: CGSize(width: 0, height: deviceWidth / 3))
        default:
            break
        }
    }
    
    func swapShapes(start: (row: Int, col: Int), end: (row: Int, col: Int), offset: CGSize) {
        withAnimation(.linear(duration: 0.3)) {
            // Apply offset animation
            offsets[start.row][start.col] = offset
            offsets[end.row][end.col] = CGSize(width: -offset.width, height: -offset.height)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // Perform the swap
            let temp = grid[start.row][start.col]
            grid[start.row][start.col] = grid[end.row][end.col]
            grid[end.row][end.col] = temp
            
            // Reset offsets
                offsets[start.row][start.col] = .zero
                offsets[end.row][end.col] = .zero
            checkWinCondition()
        }
    }
    
    func checkWinCondition() {
        if grid == targetGrid {
            self.showCelebration = true
            print("You win!")
        }
    }
}

#Preview {
    ContentView()
}
