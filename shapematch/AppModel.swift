//
//  AppModel.swift
//  shapematch
//
//  Created by Wheezy Capowdis on 8/17/24.
//

import Foundation
import SwiftUI
import GameKit

let hapticManager = HapticManager.instance

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
        repeating: Array(repeating: .zero, count: 5),
        count: 5
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
//    @Published var grid.count = 3
    @Published var swapsNeeded = 1
    @Published var shapes: [ShapeType] = []
    
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
                swapShapes(start: (row, col), end: (row, col - 1), offset: CGSize(width: -deviceWidth / ((CGFloat(grid.count) - 1) * 1.5), height: 0))
            case .right where col < grid.count - 1:
                swapShapes(start: (row, col), end: (row, col + 1), offset: CGSize(width: deviceWidth / ((CGFloat(grid.count) - 1) * 1.5), height: 0))
            case .up where row > 0:
                swapShapes(start: (row, col), end: (row - 1, col), offset: CGSize(width: 0, height: -deviceWidth / ((CGFloat(grid.count) - 1) * 1.5)))
            case .down where row < grid.count - 1:
                swapShapes(start: (row, col), end: (row + 1, col), offset: CGSize(width: 0, height: deviceWidth / ((CGFloat(grid.count) - 1) * 1.5)))
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
    
    func determineLevelSettings() {
        // Determine the number of swaps needed based on the level
        switch userPersistedData.level {
            case 1...3: swapsNeeded = 2
            case 4...11: swapsNeeded = 3
            case 12...30: swapsNeeded = 4
            case 31...50: swapsNeeded = 5
            case 51...75: swapsNeeded = 6
            case 76...105: swapsNeeded = 7
            case 106...140: swapsNeeded = 8
            case 141...199: swapsNeeded = 9
            case 200...270: swapsNeeded = 4  // Start 4x4 grid at level 200
            case 271...359: swapsNeeded = 11
            case 360...460: swapsNeeded = 12
            case 461...579: swapsNeeded = 13  // Start 4x4 grid at level 200
            case 580...699: swapsNeeded = 14
            case 700...829: swapsNeeded = 15
            case 830...999: swapsNeeded = 16
            default: swapsNeeded = 17
        }
        
        
        switch userPersistedData.level {
        case 1...199:
            shapes = [.circle, .square, .triangle]
        case 200...999:
            shapes =  [.circle, .square, .triangle, .star]
        default: 
            shapes =  [.circle, .square, .triangle, .star, .hexagon]
        }
        
        offsets = Array(
            repeating: Array(repeating: .zero, count: shapes.count),
            count: shapes.count
        )
    }
    
    func setupLevel() {
        
        determineLevelSettings()
        print("shapes count \(shapes.count)")
        // Use BFS to generate a grid that requires the exact number of swaps
        var swapsNeededMet = false
        
        while !swapsNeededMet {
            
//            let shapes: [ShapeType] = [.circle, .square, .triangle]
            var startState = (shapes) // Ensure the grid has all 9 shapes
            
            for _ in 0..<shapes.count - 1 {
                startState += shapes
            }
            
            startState.shuffle()
            
            let firstNeighbors = generateNeighbors(for: startState)
            print(firstNeighbors.count)

            // Convert startState to a 2D grid
            var assigningGrid:[[ShapeType]] = []
            for i in 0..<shapes.count {
                assigningGrid.append([])
                for _ in 0..<shapes.count {
                    assigningGrid[i].append(.circle)
                }
            }

            for i in 0..<shapes.count {
                for j in 0..<shapes.count {
                    assigningGrid[i][j] = startState[i * shapes.count + j]
                }
            }
            
            grid = assigningGrid
            
            let generatedTargetGrid = generateTargetGrid(from: grid, with: swapsNeeded)
            
            if generatedTargetGrid.isEmpty {
                print("trying again")
                
            } else {
                targetGrid = generatedTargetGrid
                swapsNeededMet = true
            }
            
        }
        persistData()
    }
    
    func generateTargetGrid(from startGrid: [[ShapeType]], with minimumSwapsToSolve: Int) -> [[ShapeType]] {
        let startState = startGrid.flatMap { $0 }
        
        var visited = Set<[ShapeType]>()
        var queue: [([ShapeType], Int)] = [(startState, 0)]  // (state, depth)
        visited.insert(startState)
        
        // Perform BFS to find a configuration requiring exactly swapsNeeded
        var assigningTargetGrid: [[ShapeType]] = []
        print("grid count: \(startGrid.count)")
        print("Got above the queue")
        
        while !queue.isEmpty {
            print("\nIn the queue")
            let (currentState, depth) = queue.removeFirst()
            
            // If we've reached the desired depth, use this state as the new initial grid
            print("depth reached \(depth)")
            if depth == minimumSwapsToSolve {
                print("depth found: \(depth)")
                
                // Use stride to efficiently convert the 1D currentState back to 2D grid
                let gridSize = startGrid.count
                for i in stride(from: 0, to: currentState.count, by: gridSize) {
                    let row = Array(currentState[i..<i + gridSize])
                    assigningTargetGrid.append(row)
                }
                
                break
            }
            
            // Generate neighbors by swapping adjacent elements
            let neighbors = generateNeighbors(for: currentState)
            
            print("neighbors count \(neighbors.count)")
            
            for neighbor in neighbors {
                if !visited.contains(neighbor) {
                    visited.insert(neighbor)
                    queue.append((neighbor, depth + 1))
                }
            }
        }
        return assigningTargetGrid
    }

    
    func persistData() {
        // The grid now requires exactly `swapsNeeded` swaps to solve
        swipesLeft = swapsNeeded
        initialSwipes = swipesLeft
        initialGrid = grid
        
        // Persist the grid and targetGrid for the current level
        userPersistedData.grid = grid
        userPersistedData.targetGrid = targetGrid
    }

    func generateNeighbors(for state: [ShapeType]) -> [[ShapeType]] {
        var neighbors = [[ShapeType]]()
        
        // Generate swaps for all adjacent elements
        for row in 0..<grid.count {
            for col in 0..<grid.count {
                let index = row * grid.count + col
                
                // Swap with the right neighbor
                if col < grid.count - 1 {
                    var newState = state
                    newState.swapAt(index, index + 1)
                    neighbors.append(newState)
                }
                
                // Swap with the bottom neighbor
                if row < grid.count - 1 {
                    var newState = state
                    newState.swapAt(index, index + grid.count)
                    neighbors.append(newState)
                }
            }
        }
        
        return neighbors
    }

    
    func resetLevel() {
        // Reset the grid to its initial configuration
        grid = initialGrid
        
        // Reset offsets to zero
        offsets = Array(
            repeating: Array(repeating: .zero, count: shapes.count),
            count: shapes.count
        )
        
        // Reset the swipes left to the initial calculated value
        swipesLeft = initialSwipes
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
    
}

extension Array where Element == [ShapeType] {
    mutating func swapAt(_ first: (row: Int, col: Int), _ second: (row: Int, col: Int)) {
        let temp = self[first.row][first.col]
        self[first.row][first.col] = self[second.row][second.col]
        self[second.row][second.col] = temp
    }
}

// Helper extension to chunk a flat array into subarrays of a given size (to reshape 1D array back to 2D

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
    case circle, square, triangle, star, hexagon
    
    var id: Int { rawValue }
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

struct HexagonShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius = min(rect.width, rect.height) / 2
        let angle = .pi / CGFloat(3)

        var path = Path()

        for i in 0..<6 {
            let pointRadius =  radius
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
        case .star:
            StarShape(points: 5)
                .foregroundColor(.yellow)
                .background(StarShape(points: 5).style(
                    withStroke: Color.black,
                    lineWidth: 18,
                    fill: Color.yellow
                ))
                .scaleEffect(0.8)
        case .hexagon:
            HexagonShape()
                .foregroundColor(.purple)
                .background(HexagonShape().style(
                    withStroke: Color.black,
                    lineWidth: 18,
                    fill: Color.yellow
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
        case .star:
            StarShape(points: 5)
                .foregroundColor(.yellow)
                .background(StarShape(points: 5).style(
                    withStroke: Color.black,
                    lineWidth: 6,
                    fill: Color.yellow
                ))
                .scaleEffect(0.8)
        case .hexagon:
            HexagonShape()
                .foregroundColor(.purple)
                .background(HexagonShape().style(
                    withStroke: Color.black,
                    lineWidth: 6,
                    fill: Color.yellow
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
