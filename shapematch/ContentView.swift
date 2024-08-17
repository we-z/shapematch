import SwiftUI

let deviceHeight = UIScreen.main.bounds.height
let deviceWidth = UIScreen.main.bounds.width

struct ContentView: View {
    @State private var grid: [[ShapeType]] = [
        [.circle, .square, .triangle],
        [.triangle, .circle, .square],
        [.square, .triangle, .circle]
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
    
    var body: some View {
        VStack {
            ForEach(0..<3) { row in
                HStack {
                    ForEach(0..<3) { column in
                        ShapeView(shapeType: grid[row][column])
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
                                        checkWinCondition()
                                    }
                            )
                    }
                }
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
        }
    }
    
    func checkWinCondition() {
        if grid == targetGrid {
            print("You win!")
        }
    }
}

enum SwipeDirection {
    case left, right, up, down
}

enum ShapeType: Int, Identifiable, Equatable {
    case circle, square, triangle
    
    var id: Int { rawValue }
}

struct ShapeView: View {
    let shapeType: ShapeType
    
    var body: some View {
        switch shapeType {
        case .circle:
            Circle().fill(Color.blue)
        case .square:
            Rectangle().fill(Color.red)
        case .triangle:
            Triangle().fill(Color.green)
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    ContentView()
}
