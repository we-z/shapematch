import SwiftUI

let deviceHeight = UIScreen.main.bounds.height
let deviceWidth = UIScreen.main.bounds.width

struct ContentView: View {
    @State var grid: [[ShapeType]] = [
        [.circle, .circle, .circle],
        [.square, .triangle, .square],
        [.triangle, .square, .triangle]
    ]
    
    @State var targetGrid: [[ShapeType]] = [
        [.circle, .circle, .circle],
        [.square, .square, .square],
        [.triangle, .triangle, .triangle]
    ]
    
    @State private var offsets: [[CGSize]] = Array(
        repeating: Array(repeating: .zero, count: 3),
        count: 3
    )
    
    @State var initialGrid: [[ShapeType]] = [[]]
    @State var initialSwipes = 0
    @State var showCelebration = false
    @State var freezeGame = false
    @State var swipesLeft = 1
    @State var level = 1
    
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
                        resetLevel()
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
                Text("Level: \(level)")
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
                                    smallShapeView(shapeType: targetGrid[row][column])
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
                        Text("\(swipesLeft)")
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
                            LargeShapeView(shapeType: grid[row][column])
                                .frame(width: deviceWidth / 4.5, height: deviceWidth / 4.5)
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
                Spacer()
            }
            if self.showCelebration {
                CelebrationEffect()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.showCelebration = false
                            level += 1
                            setupLevel()
                        }
                    }
            }
        }
        .allowsHitTesting(!self.freezeGame)
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
        withAnimation(.linear(duration: 0.1)) {
            offsets[start.row][start.col] = offset
            offsets[end.row][end.col] = CGSize(width: -offset.width, height: -offset.height)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let temp = grid[start.row][start.col]
            grid[start.row][start.col] = grid[end.row][end.col]
            grid[end.row][end.col] = temp
            
            offsets[start.row][start.col] = .zero
            offsets[end.row][end.col] = .zero
            checkWinCondition()
        }
    }
    
    func checkWinCondition() {
        if grid == targetGrid {
            showCelebration = true
            self.freezeGame = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.freezeGame = false
            }
            print("You win!")
        } else if swipesLeft <= 0 {
            print("Level failed")
        }
    }
    
    func setupLevel() {
        let shapes: [ShapeType] = [.circle, .square, .triangle]
        
        // Create a grid with each shape repeated enough times and then shuffled
        let randomizedShapes = (shapes + shapes + shapes).shuffled()
        
        // Populate the grid by taking the first 9 elements
        for i in 0..<3 {
            grid[i] = Array(randomizedShapes[(i * 3)..<(i * 3 + 3)])
        }
        
        initialGrid = grid
        
        // Shuffle the target grid to create a different target pattern
        targetGrid = grid.shuffled()
        
        // Determine the number of swipes needed
        swipesLeft = calculateSwipesNeeded()
        initialSwipes = swipesLeft
    }
    
    func calculateSwipesNeeded() -> Int {
        // This function should determine the exact number of swipes needed to solve the grid
        // For simplicity, we're assigning a random number between 3 and 10, but you could implement
        // a more sophisticated logic to count the real swipes needed.
        return Int.random(in: 3...10)
    }
    
    func resetLevel() {
            // Reset the grid to its initial configuration
            grid = initialGrid
            
            // Reset offsets to zero
            offsets = Array(
                repeating: Array(repeating: .zero, count: 3),
                count: 3
            )
            
            // Reset the swipes left to the initial calculated value
            swipesLeft = initialSwipes
        }
    
}

#Preview {
    ContentView()
}
