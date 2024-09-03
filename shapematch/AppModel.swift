//
//  AppModel.swift
//  shapematch
//
//  Created by Wheezy Capowdis on 8/17/24.
//

import Foundation
import SwiftUI
import GameKit


class AppModel: ObservableObject {
    static let sharedAppModel = AppModel()
    let hapticManager = HapticManager.instance
    @Published var shouldBurst = false
    @Published var grid: [[ShapeType]] = [
        [.square, .triangle, .circle],
        [.triangle, .circle, .circle],
        [.square, .square, .triangle]
    ]
    
    @Published var targetGrid: [[ShapeType]] = [
        [.square, .triangle, .circle],
        [.triangle, .square, .circle],
        [.square, .circle, .triangle]
    ]
    
    @Published var offsets: [[CGSize]] = Array(
        repeating: Array(repeating: .zero, count: 3),
        count: 3
    )
    
    @Published var initialGrid: [[ShapeType]] = [[]]
    @Published var initialSwipes = 1
    @Published var swipesLeft = 1
    @Published var freezeGame = false
    @Published var swapsToSell = 1
    @Published var showNoMoreSwipesView = false
    @Published var secondGamePlayed = false
    @Published var showGemMenu = false
    @Published var showInstruction = false
    @Published var showNewGoal = false
    @Published var swaping = false
    
    @ObservedObject var audioController = AudioManager.sharedAudioManager
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    
    init() {
        // Initialize the grids from persisted data
        grid = userPersistedData.grid.isEmpty ? [
            [.square, .triangle, .circle],
            [.triangle, .circle, .circle],
            [.square, .square, .triangle]
        ] : userPersistedData.grid
        
        targetGrid = userPersistedData.targetGrid.isEmpty ? [
            [.square, .triangle, .circle],
            [.triangle, .square, .circle],
            [.square, .circle, .triangle]
        ] : userPersistedData.targetGrid
        
        swipesLeft = calculateMinimumSwipes(from: grid, to: targetGrid)
    }
    
    func handleSwipeGesture(gesture: DragGesture.Value, row: Int, col: Int) {
        let direction: SwipeDirection
        
        if abs(gesture.translation.width) > abs(gesture.translation.height) {
            direction = gesture.translation.width < 0 ? .left : .right
        } else {
            direction = gesture.translation.height < 0 ? .up : .down
        }
        
        if !swaping {
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
    }
    
    func swapShapes(start: (row: Int, col: Int), end: (row: Int, col: Int), offset: CGSize) {
        DispatchQueue.main.async { [self] in
            self.swaping = true
            withAnimation(.linear(duration: 0.2)) {
                offsets[start.row][start.col] = offset
                offsets[end.row][end.col] = CGSize(width: -offset.width, height: -offset.height)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
            let temp = grid[start.row][start.col]
            grid[start.row][start.col] = grid[end.row][end.col]
            grid[end.row][end.col] = temp
             
            offsets[start.row][start.col] = .zero
            offsets[end.row][end.col] = .zero
            swaping = false
        }
        
        if grid[start.row][start.col] == grid[end.row][end.col] {
                // If they are the same, do nothing
            hapticManager.notification(type: .error)
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            self.swipesLeft -= 1
            AudioServicesPlaySystemSound(1104)
            impactHeavy.impactOccurred()
            checkWinCondition()
        }
        
    }
    
    func checkWinCondition() {
        if grid == targetGrid {
            DispatchQueue.main.async { [self] in
                shouldBurst.toggle()
            }
            userPersistedData.firstGamePlayed = true
            if userPersistedData.level == 2 {
                secondGamePlayed = true
            }
            self.freezeGame = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [self] in
                if userPersistedData.level == 1 {
                    showNewGoal.toggle()
                }
                userPersistedData.level += 1
                setupLevel()
                swipesLeft =  calculateMinimumSwipes(from:  grid, to:  targetGrid)
                initialSwipes = calculateMinimumSwipes(from:  grid, to:  targetGrid)
                self.freezeGame = false
            }
            print("You win!")
        } else if swipesLeft <= 0 {
            swapsToSell = calculateMinimumSwipes(from: grid, to: targetGrid)
            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
            showNoMoreSwipesView = true
            print("Level failed")
        }
    }
    
    func setupLevel() {
        let shapes: [ShapeType] = [.circle, .square, .triangle]
        let randomizedShapes = (shapes + shapes + shapes).shuffled()

        // Populate the grid with randomized shapes
        for i in 0..<3 {
            grid[i] = Array(randomizedShapes[(i * 3)..<(i * 3 + 3)])
        }
        
        initialGrid = grid
        targetGrid = grid
        var swapsNeeded = 2
        
        switch userPersistedData.level {
        case 1...5: swapsNeeded = 2
        case 6...15: swapsNeeded = 3
        case 16...30: swapsNeeded = 4
        case 31...50: swapsNeeded = 5
        case 51...75: swapsNeeded = 6
        case 76...105: swapsNeeded = 7
        case 106...140: swapsNeeded = 8
        default: swapsNeeded = 9
        }
        
        var successfulSetup = false
            
        while !successfulSetup {
            // Create a target grid that requires the correct number of swaps to solve
            for _ in 0..<swapsNeeded {
                var (row1, col1, row2, col2) = (0, 0, 0, 0)
                repeat {
                    row1 = Int.random(in: 0..<3)
                    col1 = Int.random(in: 0..<3)
                    let direction = Int.random(in: 0..<4)
                    (row2, col2) = direction == 0 ? (row1, col1 > 0 ? col1 - 1 : col1 + 1) :
                                   direction == 1 ? (row1, col1 < 2 ? col1 + 1 : col1 - 1) :
                                   direction == 2 ? (row1 > 0 ? row1 - 1 : row1 + 1, col1) :
                                   (row1 < 2 ? row1 + 1 : row1 - 1, col1)
                } while (row1 == row2 && col1 == col2) || targetGrid[row1][col1] == targetGrid[row2][col2]
                
                // Perform the swap
                let temp = targetGrid[row1][col1]
                targetGrid[row1][col1] = targetGrid[row2][col2]
                targetGrid[row2][col2] = temp
            }
            
            // Check if the grid requires exactly `swapsNeeded` to solve
            let calculatedSwipes = calculateMinimumSwipes(from: grid, to: targetGrid)
            if calculatedSwipes == swapsNeeded {
                successfulSetup = true
                swipesLeft = swapsNeeded
                initialSwipes = swipesLeft
                userPersistedData.grid = grid
                userPersistedData.targetGrid = targetGrid
                
            } else {
                // If the calculated swipes do not match, reset and try again
                targetGrid = grid
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
        swipesLeft = calculateMinimumSwipes(from: grid, to: targetGrid)
        initialSwipes = swipesLeft
    }
    
    func calculateMinimumSwipes(from startGrid: [[ShapeType]], to targetGrid: [[ShapeType]]) -> Int {
        // Convert grid to a one-dimensional array for easier comparison and manipulation
        let startState = startGrid.flatMap { $0 }
        let targetState = targetGrid.flatMap { $0 }
        
        if startState == targetState {
            return 0
        }
        
        // BFS setup
        var visited = Set<[ShapeType]>()
        var queue: [([ShapeType], Int)] = [(startState, 0)]
        visited.insert(startState)
        
        // BFS loop
        while !queue.isEmpty {
            let (currentState, depth) = queue.removeFirst()
            
            // Generate all possible adjacent swaps
            let neighbors = generateNeighbors(for: currentState)
            
            for neighbor in neighbors {
                if neighbor == targetState {
                    return depth + 1
                }
                
                if !visited.contains(neighbor) {
                    visited.insert(neighbor)
                    queue.append((neighbor, depth + 1))
                }
            }
        }
        
        // If no solution is found, return an impossible number
        return Int.max
    }

    func generateNeighbors(for state: [ShapeType]) -> [[ShapeType]] {
        var neighbors = [[ShapeType]]()
        
        // We need to swap adjacent positions in the grid
        let gridSize = 3
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let index = row * gridSize + col
                
                // Swap with the right neighbor
                if col < gridSize - 1 {
                    var newState = state
                    newState.swapAt(index, index + 1)
                    neighbors.append(newState)
                }
                
                // Swap with the bottom neighbor
                if row < gridSize - 1 {
                    var newState = state
                    newState.swapAt(index, index + gridSize)
                    neighbors.append(newState)
                }
            }
        }
        
        return neighbors
    }
    
}

class HapticManager {
    static let instance = HapticManager()
    private init() {}
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)

enum SwipeDirection {
    case left, right, up, down
}

enum ShapeType: Int, Identifiable, Equatable, CaseIterable {
    case circle, square, triangle
    
    var id: Int { rawValue }
}

enum ExtendedShapeType: Int, Identifiable, Equatable, CaseIterable {
    case circle, square, triangle, star // Added star as the new shape
    
    var id: Int { rawValue }
}

struct ExtendedLargeShapeView: View {
    let shapeType: ExtendedShapeType
    
    var body: some View {
        switch shapeType {
        case .circle:
            Circle().fill(Color.blue)
                .background(Circle().style(
                    withStroke: Color.black,
                    lineWidth: 18,
                    fill: Color.blue
                ))
        case .square:
            Rectangle().fill(Color.red)
                .background(Rectangle().style(
                    withStroke: Color.black,
                    lineWidth: 18,
                    fill: Color.red
                ))
        case .triangle:
            Triangle()
                .foregroundColor(.green)
                .background(Triangle().style(
                    withStroke: Color.black,
                    lineWidth: 18,
                    fill: Color.green
                ))
        case .star: // Handle the new star shape
            StarShape(points: 5)
                .foregroundColor(.yellow)
                .background(StarShape(points: 5).style(
                    withStroke: Color.black,
                    lineWidth: 18,
                    fill: Color.yellow
                ))
        }
    }
}

struct StarShape: Shape {
    var points: Int
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius = min(rect.width, rect.height) / 2
        let angle = .pi / CGFloat(points)

        var path = Path()

        for i in 0..<2 * points {
            let isEven = i % 2 == 0
            let pointRadius = isEven ? radius : radius * 0.4
            let xPosition = center.x + pointRadius * sin(CGFloat(i) * angle)
            let yPosition = center.y - pointRadius * cos(CGFloat(i) * angle)

            let point = CGPoint(x: xPosition, y: yPosition)

            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }

        path.closeSubpath()

        return path
    }
}

struct LargeShapeView: View {
    let shapeType: ShapeType
    
    var body: some View {
        switch shapeType {
        case .circle:
            Circle().fill(Color.blue)
                .background(Circle().style(
                    withStroke: Color.black,
                    lineWidth: 18,
                    fill: Color.blue
                ))
        case .square:
            Rectangle().fill(Color.red)
                .background(Rectangle().style(
                    withStroke: Color.black,
                    lineWidth: 18,
                    fill: Color.red
                ))
        case .triangle:
            Triangle()
                .foregroundColor(.green)
                .background(Triangle().style(
                    withStroke: Color.black,
                    lineWidth: 18,
                    fill: Color.green
                ))
        }
    }
}

struct smallShapeView: View {
    let shapeType: ShapeType
    
    var body: some View {
        switch shapeType {
        case .circle:
            Circle().fill(Color.blue)
                .background(Circle().style(
                    withStroke: Color.black,
                    lineWidth: 6,
                    fill: Color.blue
                ))
        case .square:
            Rectangle().fill(Color.red)
                .background(Rectangle().style(
                    withStroke: Color.black,
                    lineWidth: 6,
                    fill: Color.red
                ))
        case .triangle:
            Triangle()
                .foregroundColor(.green)
                .background(Triangle().style(
                    withStroke: Color.black,
                    lineWidth: 6,
                    fill: Color.green
                ))
        }
    }
}

extension Shape {
    func style<S: ShapeStyle, F: ShapeStyle>(
        withStroke strokeContent: S,
        lineWidth: CGFloat = 1,
        fill fillContent: F
    ) -> some View {
        self.stroke(strokeContent, lineWidth: lineWidth)
    .background(fill(fillContent))
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

struct CustomTextStrokeModifier: ViewModifier {
    var id = UUID()
    var strokeSize: CGFloat = 1
    var strokeColor: Color = .black

    func body(content: Content) -> some View {
        if strokeSize > 0 {
            appliedStrokeBackground(content: content)
        } else {
            content
        }
    }

    func appliedStrokeBackground(content: Content) -> some View {
        
        content
            .background(
                Rectangle()
                    .foregroundColor(strokeColor)
                    .mask {
                        mask(content: content)
                    }
                    .padding(-10)
                    .allowsHitTesting(false)
            )
            .foregroundColor(.white)
    }

    func mask(content: Content) -> some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.01))
            if let resolvedView = context.resolveSymbol(id: id) {
                context.draw(resolvedView, at: .init(x: size.width/2, y: size.height/2))
            }
        } symbols: {
            content
                .tag(id)
                .blur(radius: idiom == .pad ? strokeSize * 2 : strokeSize)
        }
    }
}

extension View {
    func customTextStroke(color: Color = .black, width: CGFloat = 2.1) -> some View {
        self.modifier(CustomTextStrokeModifier(strokeSize: width, strokeColor: color))
    }
}

extension ButtonStyle where Self == RoundedAndShadowButtonStyle6 {
    static var roundedAndShadow6:RoundedAndShadowButtonStyle6 {
        RoundedAndShadowButtonStyle6()
    }
}

struct RoundedAndShadowButtonStyle6:ButtonStyle {
    @State var isPressed = false
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .compositingGroup()
            .shadow(color: .black, radius: 0.1, x: isPressed ? 0 : -6, y: isPressed ? 0 : 6)
            .offset(x: isPressed ? -6 : 0, y: isPressed ? 6 : 0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
            .onChange(of: configuration.isPressed) { currentlyPressing in
                if currentlyPressing {
                    impactHeavy.impactOccurred()
                }
                isPressed = true
                if !currentlyPressing {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [self] in
                        isPressed = false
                        impactHeavy.impactOccurred()
                    }
                }
            }
    }
}


extension View {
  @inlinable
  public func reverseMask<Mask: View>(
    alignment: Alignment = .center,
    @ViewBuilder _ mask: () -> Mask
  ) -> some View {
    self.mask {
      Rectangle()
        .overlay(alignment: alignment) {
          mask()
            .blendMode(.destinationOut)
        }
    }
  }
}

