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
    @State var freezeGame = false
    @State var swipesLeft = 1
    @State var level = 1
    
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
                                            if swipesLeft > 0 {
                                                handleSwipeGesture(gesture: gesture, row: row, col: column)
                                                swipesLeft -= 1
                                                impactHeavy.impactOccurred()
                                            }
                                        }
                                )
                        }
                    }
                }
                Spacer()
            }
            CelebrationEffect()
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
            appModel.shouldBurst.toggle()
            self.freezeGame = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.freezeGame = false
                    level += 1
                    setupLevel()
            }
            print("You win!")
        } else if swipesLeft <= 0 {
            print("Level failed")
        }
    }
    
    func setupLevel() {
        let shapes: [ShapeType] = [.circle, .square, .triangle]
        
        // Create a grid with each shape repeated enough times and then shuffled
        var randomizedShapes = (shapes + shapes + shapes).shuffled()
        
        // Populate the grid by taking the first 9 elements
        for i in 0..<3 {
            grid[i] = Array(randomizedShapes[(i * 3)..<(i * 3 + 3)])
        }
        
        initialGrid = grid
        var successfulSetup = false
        
        while !successfulSetup {
            // Copy the initial grid to the targetGrid
            targetGrid = grid
            
            // Set swipesLeft equal to the current level
            swipesLeft = level
            
            // Perform a series of valid adjacent swaps to create a targetGrid that requires exactly `level` moves to solve
            var previousSwap: ((Int, Int), (Int, Int))? = nil
            for _ in 0..<level {
                var row1: Int
                var col1: Int
                var row2: Int
                var col2: Int
                
                repeat {
                    // Randomly select a starting position
                    row1 = Int.random(in: 0..<3)
                    col1 = Int.random(in: 0..<3)
                    
                    // Randomly select a direction to swap with an adjacent position
                    let direction = Int.random(in: 0..<4)
                    
                    switch direction {
                    case 0: // Left
                        row2 = row1
                        col2 = col1 > 0 ? col1 - 1 : col1 + 1
                    case 1: // Right
                        row2 = row1
                        col2 = col1 < 2 ? col1 + 1 : col1 - 1
                    case 2: // Up
                        row2 = row1 > 0 ? row1 - 1 : row1 + 1
                        col2 = col1
                    default: // Down
                        row2 = row1 < 2 ? row1 + 1 : row1 - 1
                        col2 = col1
                    }
                } while (row1 == row2 && col1 == col2) ||
                         (previousSwap != nil && previousSwap!.0 == (row2, col2) && previousSwap!.1 == (row1, col1)) ||
                         (targetGrid[row1][col1] == targetGrid[row2][col2])  // Check if the shapes are the same
                
                // Swap the shapes in the targetGrid
                let temp = targetGrid[row1][col1]
                targetGrid[row1][col1] = targetGrid[row2][col2]
                targetGrid[row2][col2] = temp
                
                // Store the swap to prevent an immediate reverse
                previousSwap = ((row1, col1), (row2, col2))
            }
            
            // Check if the grid and targetGrid are different
            if grid != targetGrid {
                successfulSetup = true
            } else {
                // If they are the same, shuffle and try again
                randomizedShapes.shuffle()
                for i in 0..<3 {
                    grid[i] = Array(randomizedShapes[(i * 3)..<(i * 3 + 3)])
                }
            }
        }
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
            swipesLeft = level
        }
    
}

#Preview {
    ContentView()
}
