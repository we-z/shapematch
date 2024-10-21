//
//  AppModel.swift
//  shapematch
//
//  Created by Wheezy Capowdis on 8/17/24.
//

import Foundation
import SwiftUI
import AVFoundation

let hapticManager = HapticManager.instance

class AppModel: ObservableObject {
    static let sharedAppModel = AppModel()
    let hapticManager = HapticManager.instance
    @Published var shouldBurst = false
    @Published var boughtGems = false
    @Published var grid: [[ShapeType]] = [] {
        didSet {
            if grid.count == 3 {
                shapeWidth = deviceWidth / 4.0
                shapeScale = deviceWidth / 390
            } else if grid.count == 4 {
                shapeWidth = deviceWidth / 5.3
                shapeScale = deviceWidth / 540
            } else if grid.count == 5 {
                shapeWidth = deviceWidth / 6.6
                shapeScale = deviceWidth / 690
            }
        }
    }
    
    
    @Published var offsets: [[CGSize]] = Array(
        repeating: Array(repeating: .zero, count: 5),
        count: 5
    )
    
    @Published var initialGrid: [[ShapeType]] = [[]]
    @Published var swipesLeft = 1
    @Published var freezeGame = false
    @Published var showNoMoreSwipesView = false
    @Published var secondGamePlayed = false
    @Published var showGemMenu = false
    @Published var showInstruction = false
    @Published var showNewGoal = false
    @Published var swaping = false
    @Published var shuffleBackground = false
    @Published var shapeWidth = 0.0
    @Published var shapeScale = 1.0
    @Published var showMovesCard = false
    @Published var showSettings = false
    @Published var showLevelComplete = false
    @Published var showCelebration = false
    @Published var showNewLevelAnimation = false
//    @Published var grid.count = 3
    @Published var swapsNeeded = 1
    @Published var undosLeft = 3
    @Published var amountBought = 5
    @Published var shapes: [ShapeType] = [] {
        didSet {
            self.winningGrids = generateAllWinningGrids(shapes: shapes)
        }
    }
    @Published var swapsMade: [(Position, Position)] = []
    @Published var winningGrids:[[[ShapeType]]] = []
    @Published var selectedTab = 1 {
        didSet {
            userPersistedData.selectedTab = selectedTab
        }
    }
    
    @ObservedObject var audioController = AudioManager.sharedAudioManager
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    
    init() {
        
        selectedTab = userPersistedData.selectedTab
        // Initialize the grids from persisted data
        (swapsNeeded, shapes) = determineLevelSettings(level: userPersistedData.level)
        
        grid = userPersistedData.grid.isEmpty ? [
            [.circle, .circle, .circle],
            [.square, .triangle, .square],
            [.triangle, .square, .triangle]
        ] : userPersistedData.grid
        
        
        if userPersistedData.level == 1 {
            swipesLeft = 1
        } else {
            swipesLeft = swapsNeeded
        }
        if grid.count == 3 {
            shapeWidth = deviceWidth / 4.0
            shapeScale = deviceWidth / 390
        } else if grid.count == 4 {
            shapeWidth = deviceWidth / 5.3
            shapeScale = deviceWidth / 540
        } else if grid.count == 5 {
            shapeWidth = deviceWidth / 6.6
            shapeScale = deviceWidth / 690
        }
    }
    
    func handleSwipeGesture(gesture: DragGesture.Value, row: Int, col: Int) {
        print("handleSwipeGesture called")
        let direction: SwipeDirection
        
        if abs(gesture.translation.width) > abs(gesture.translation.height) {
            direction = gesture.translation.width < 0 ? .left : .right
        } else {
            direction = gesture.translation.height < 0 ? .up : .down
        }
        
        if !swaping {
            switch direction {
            case .left where col > 0:
                swapShapes(start: (row, col), end: (row, col - 1), offset: CGSize(width: -deviceWidth / ((CGFloat(grid.count))), height: 0))
            case .right where col < grid.count - 1:
                swapShapes(start: (row, col), end: (row, col + 1), offset: CGSize(width: deviceWidth / ((CGFloat(grid.count))), height: 0))
            case .up where row > 0:
                swapShapes(start: (row, col), end: (row - 1, col), offset: CGSize(width: 0, height: -deviceWidth / ((CGFloat(grid.count)))))
            case .down where row < grid.count - 1:
                swapShapes(start: (row, col), end: (row + 1, col), offset: CGSize(width: 0, height: deviceWidth / ((CGFloat(grid.count)))))
            default:
                break
            }
        }
    }
    
    func swapShapes(start: (row: Int, col: Int), end: (row: Int, col: Int), offset: CGSize) {
        print("swapShapes called")
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
            hapticManager.notification(type: .error)
            return
        }
        if userPersistedData.soundOn {
            AudioServicesPlaySystemSound(1105)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            self.swipesLeft -= 1
            swapsMade.append((Position(row: start.row, col: start.col), Position(row: end.row, col: end.col)))
            if userPersistedData.hapticsOn {
                impactLight.impactOccurred()
            }
            checkWinCondition()
        }
    }
    
    func undoSwap() {
        if undosLeft == 0 {
            if userPersistedData.gemBalance >= 3 {
                userPersistedData.decrementBalance(amount: 3)
                undosLeft += 3
            } else {
                showGemMenu = true
            }
        } else {
            if !swapsMade.isEmpty {
                undosLeft -= 1
                let lastSwap = swapsMade.removeLast()
                if userPersistedData.soundOn {
                    AudioServicesPlaySystemSound(1105)
                }
                DispatchQueue.main.asyncAfter(deadline: .now()) { [self] in
                    let temp = grid[lastSwap.0.row][lastSwap.0.col]
                    grid[lastSwap.0.row][lastSwap.0.col] = grid[lastSwap.1.row][lastSwap.1.col]
                    grid[lastSwap.1.row][lastSwap.1.col] = temp
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now()) { [self] in
                    self.swipesLeft += 1
                }
                
            }
        }
    }
    
    func isAlignedHorizontally(grid: [[ShapeType]]) -> Bool {
        for row in grid {
            if Set(row).count != 1 {
                return false
            }
        }
        return true
    }

    func isAlignedVertically(grid: [[ShapeType]]) -> Bool {
        let columnCount = grid[0].count
        for col in 0..<columnCount {
            var columnShapes = [ShapeType]()
            for row in grid {
                columnShapes.append(row[col])
            }
            if Set(columnShapes).count != 1 {
                return false
            }
        }
        return true
    }

    func isWinningGrid(grid: [[ShapeType]]) -> Bool {
        return isAlignedHorizontally(grid: grid) || isAlignedVertically(grid: grid)
    }

    func updateStars() {
        if swipesLeft > 1 || userPersistedData.level == 1 {
            if let levelStars = userPersistedData.levelStars[String(userPersistedData.level)] {
                if levelStars < 3 {
                    userPersistedData.incrementBalance(amount: 1)
                    userPersistedData.levelStars[String(userPersistedData.level)] = 3
                }
            } else {
                userPersistedData.incrementBalance(amount: 1)
                userPersistedData.levelStars[String(userPersistedData.level)] = 3
            }
        } else if swipesLeft > 0 {
            if let levelStars = userPersistedData.levelStars[String(userPersistedData.level)] {
                if levelStars <= 2 {
                    userPersistedData.levelStars[String(userPersistedData.level)] = 2
                }
            } else {
                userPersistedData.levelStars[String(userPersistedData.level)] = 2
            }
        } else {
            if let levelStars = userPersistedData.levelStars[String(userPersistedData.level)] {
                if levelStars <= 1 {
                    userPersistedData.levelStars[String(userPersistedData.level)] = 1
                }
            } else {
                userPersistedData.levelStars[String(userPersistedData.level)] = 1
            }
        }
    }
    
    func checkWinCondition() {
        if isWinningGrid(grid: grid) {
            updateStars()
            userPersistedData.firstGamePlayed = true
            // 1335, 1114
            if userPersistedData.soundOn {
                AudioServicesPlaySystemSound(1114)
            }
            if userPersistedData.level == userPersistedData.highestLevel {
                userPersistedData.highestLevel += 1
            }
            DispatchQueue.main.async { [self] in
                showCelebration = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
                showLevelComplete = true
            }
            print("You win!")
        } else if swipesLeft <= 0 {
            if userPersistedData.soundOn {
                AudioServicesPlaySystemSound (1053)
            }
            if userPersistedData.hapticsOn {
                AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
            }
            if userPersistedData.level == 1 {
                setupFirstLevel()
            } else {
                showNoMoreSwipesView = true
            }
            print("Level failed")
        }
    }
    
    func determineLevelSettings(level: Int) -> (Int, [ShapeType]) {
        // Determine the number of swaps needed based on the level
        
        var swapsNeeded = 0
        var shapes: [ShapeType] = []
        switch level {
        case 1:
            swapsNeeded = 1
        case 2...7:
            swapsNeeded = 2
        case 8...16:
            swapsNeeded = 3
        case 17...28:
            swapsNeeded = 4
        case 29...40:
            swapsNeeded = 4
        case 41...55:
            swapsNeeded = 5
        case 56...73:
            swapsNeeded = 6
        case 74...94:
            swapsNeeded = 7
        case 95...119:
            swapsNeeded = 8
        case 120...146:
            swapsNeeded = 9
        case 147...176:
            swapsNeeded = 10
        case 177...209:
            swapsNeeded = 11
        case 210...242:
            swapsNeeded = 11
        case 243...278:
            swapsNeeded = 12
        case 279...317:
            swapsNeeded = 13
        case 318...359:
            swapsNeeded = 14
        case 360...404:
            swapsNeeded = 15
        case 405...452:
            swapsNeeded = 16
        case 453...503:
            swapsNeeded = 17
        case 504...557:
            swapsNeeded = 18
        case 558...614:
            swapsNeeded = 19
        case 615...674:
            swapsNeeded = 20
        case 675...737:
            swapsNeeded = 21
        default:
            swapsNeeded = 22
        }

        
        switch level {
        case 1...28:
            shapes = [.circle, .square, .triangle]
        case 29...209:
            shapes =  [.circle, .square, .triangle, .star]
        default: 
            shapes =  [.circle, .square, .triangle, .star, .heart]
        }
        
//        offsets = Array(
//            repeating: Array(repeating: .zero, count: shapes.count),
//            count: shapes.count
//        )
        
        return (swapsNeeded, shapes)
    }
    
    func permutationsOf<T>(_ elements: [T]) -> [[T]] {
        var result = [[T]]()
        var elements = elements
        permute(&elements, start: 0, result: &result)
        return result
    }
    
    func permute<T>(_ elements: inout [T], start: Int, result: inout [[T]]) {
        if start == elements.count {
            result.append(elements)
        } else {
            for i in start..<elements.count {
                elements.swapAt(start, i)
                permute(&elements, start: start + 1, result: &result)
                elements.swapAt(start, i)
            }
        }
    }
    
    func generateAllWinningGrids(shapes: [ShapeType]) -> [[[ShapeType]]] {
        let N = shapes.count
        var winningGrids = [[[ShapeType]]]()
        let permutations = permutationsOf(shapes)
        
        // Horizontal alignment
        for perm in permutations {
            var grid = [[ShapeType]](repeating: [ShapeType](repeating: shapes[0], count: N), count: N)
            for i in 0..<N {
                let shape = perm[i]
                grid[i] = [ShapeType](repeating: shape, count: N)
            }
            winningGrids.append(grid)
        }
        
        // Vertical alignment
        for perm in permutations {
            var grid = [[ShapeType]](repeating: [ShapeType](repeating: shapes[0], count: N), count: N)
            for i in 0..<N {
                let shape = perm[i]
                for j in 0..<N {
                    grid[j][i] = shape
                }
            }
            winningGrids.append(grid)
        }
        
        return winningGrids
    }
    
    func minimumMovesToSolve(generatedGrid: [[ShapeType]]) -> Int {
        let shapeTypes = Array(Set(generatedGrid.flatMap { $0 }))

        var minTotalCost = Int.max

        // Compute minimal total cost for horizontal alignment
        let horizontalCost = computeMinimalTotalCost(generatedGrid: generatedGrid, alignment: .horizontal, shapeTypes: shapeTypes)
        minTotalCost = min(minTotalCost, horizontalCost)

        // Compute minimal total cost for vertical alignment
        let verticalCost = computeMinimalTotalCost(generatedGrid: generatedGrid, alignment: .vertical, shapeTypes: shapeTypes)
        minTotalCost = min(minTotalCost, verticalCost)

        return Int(ceil(Double(minTotalCost) / 2.0))
    }

    enum Alignment {
        case horizontal
        case vertical
    }

    func computeMinimalTotalCost(generatedGrid: [[ShapeType]], alignment: Alignment, shapeTypes: [ShapeType]) -> Int {
        let N = generatedGrid.count
        var costMatrix = [[Int]](repeating: [Int](repeating: 0, count: N), count: N)

        // currentPositions[s]: positions of shapeType s (indexed by sIndex)
        var currentPositions = [[Position]](repeating: [], count: N)
        for (rowIndex, row) in generatedGrid.enumerated() {
            for (colIndex, shape) in row.enumerated() {
                if let sIndex = shapeTypes.firstIndex(of: shape) {
                    currentPositions[sIndex].append(Position(row: rowIndex, col: colIndex))
                }
            }
        }

        for sIndex in 0..<N {
            for r in 0..<N {
                var targetPositions = [Position]()
                if alignment == .horizontal {
                    for col in 0..<N {
                        targetPositions.append(Position(row: r, col: col))
                    }
                } else {
                    for row in 0..<N {
                        targetPositions.append(Position(row: row, col: r))
                    }
                }
                let cost = minimalTotalMatchingCost(startPositions: currentPositions[sIndex], targetPositions: targetPositions)
                costMatrix[sIndex][r] = cost
            }
        }

        // Solve the Assignment Problem using the Hungarian Algorithm
        let totalCost = hungarianAlgorithm(costMatrix: costMatrix)
        return totalCost
    }

    func minimalTotalMatchingCost(startPositions: [Position], targetPositions: [Position]) -> Int {
        guard startPositions.count == targetPositions.count else {
            fatalError("Positions counts do not match")
        }
        
        let n = startPositions.count
        if n == 0 {
            return 0
        }
        
        // Create the cost matrix where costMatrix[i][j] is the cost of assigning startPositions[i] to targetPositions[j]
        var costMatrix = [[Int]](repeating: [Int](repeating: 0, count: n), count: n)
        for i in 0..<n {
            for j in 0..<n {
                costMatrix[i][j] = abs(startPositions[i].row - targetPositions[j].row) + abs(startPositions[i].col - targetPositions[j].col)
            }
        }
        
        // Use the Hungarian Algorithm to find the minimal total matching cost
        let totalCost = hungarianAlgorithm(costMatrix: costMatrix)
        return totalCost
    }

    func hungarianAlgorithm(costMatrix: [[Int]]) -> Int {
        let n = costMatrix.count
        var u = [Int](repeating: 0, count: n + 1)
        var v = [Int](repeating: 0, count: n + 1)
        var p = [Int](repeating: 0, count: n + 1)
        var way = [Int](repeating: 0, count: n + 1)
        
        for i in 1...n {
            p[0] = i
            var minv = [Int](repeating: Int.max, count: n + 1)
            var used = [Bool](repeating: false, count: n + 1)
            var j0 = 0
            repeat {
                used[j0] = true
                let i0 = p[j0]
                var delta = Int.max
                var j1 = 0
                for j in 1...n {
                    if !used[j] {
                        let cur = costMatrix[i0 - 1][j - 1] - u[i0] - v[j]
                        if cur < minv[j] {
                            minv[j] = cur
                            way[j] = j0
                        }
                        if minv[j] < delta {
                            delta = minv[j]
                            j1 = j
                        }
                    }
                }
                for j in 0...n {
                    if used[j] {
                        u[p[j]] += delta
                        v[j] -= delta
                    } else {
                        minv[j] -= delta
                    }
                }
                j0 = j1
            } while p[j0] != 0
            repeat {
                let j1 = way[j0]
                p[j0] = p[j1]
                j0 = j1
            } while j0 != 0
        }
        
        // The minimal total cost is stored in -v[0]
        return -v[0]
    }

    func generateTargetGrid(from shapes: [ShapeType], with swapsNeeded: Int) -> [[ShapeType]] {
        var targetGrid = randomAlignedGrid(shapes: shapes)
//        var previousPositions: [ShapeType: Set<Position>] = [:]
        var possiblePositions: [Position] = []
        let gridSize = shapes.count

        // Initialize possiblePositions with the starting positions
        func setPossiblePositions() {
            for row in 0..<gridSize {
                for col in 0..<gridSize {
                    let position = Position(row: row, col: col)
                    possiblePositions.append(position)
                }
            }
        }
        
        setPossiblePositions()
        
        var swapMadeOnPosition = false
        var swapsMade = 0
        var iterations = 0
        let maxIterations = 1000

        while swapsMade < swapsNeeded && iterations < maxIterations {
            iterations += 1
            swapMadeOnPosition = false
            let currentPosition = possiblePositions.randomElement() ?? Position(row: 0, col: 0)

            var possibleSwaps = [(Int, Int)]()
            if currentPosition.row > 0 && targetGrid[currentPosition.row][currentPosition.col] != targetGrid[currentPosition.row - 1][currentPosition.col] {
                possibleSwaps.append((currentPosition.row - 1, currentPosition.col))
            }
            if currentPosition.row < gridSize - 1 && targetGrid[currentPosition.row][currentPosition.col] != targetGrid[currentPosition.row + 1][currentPosition.col] {
                possibleSwaps.append((currentPosition.row + 1, currentPosition.col))
            }
            if currentPosition.col > 0 && targetGrid[currentPosition.row][currentPosition.col] != targetGrid[currentPosition.row][currentPosition.col - 1] {
                possibleSwaps.append((currentPosition.row, currentPosition.col - 1))
            }
            if currentPosition.col < gridSize - 1 && targetGrid[currentPosition.row][currentPosition.col] != targetGrid[currentPosition.row][currentPosition.col + 1] {
                possibleSwaps.append((currentPosition.row, currentPosition.col + 1))
            }
            
            for (swapRow, swapCol) in possibleSwaps {
                let pos1 = Position(row: currentPosition.row, col: currentPosition.col)
                let pos2 = Position(row: swapRow, col: swapCol)
                
                // Perform the swap
                targetGrid.swapAt((pos1.row, pos1.col), (pos2.row, pos2.col))
                
                let newMinMoves = minimumMovesToSolve(generatedGrid: targetGrid)
                
                print("newMinMoves \(newMinMoves)")
                
                if newMinMoves > swapsMade {
                    swapMadeOnPosition = true
                    swapsMade += 1
                    setPossiblePositions()
                    break
                } else {
                    targetGrid.swapAt((pos1.row, pos1.col), (pos2.row, pos2.col))
                }
            }
            
            if !swapMadeOnPosition {
                possiblePositions.removeAll(where: { $0 == currentPosition })
            }
            
            if possiblePositions.isEmpty {
                print("ran out of possible Positions. trying again")
                swapsMade = 0
                setPossiblePositions()
            }
        }

        if iterations >= maxIterations {
            print("Could not generate target grid with desired difficulty within iteration limit.")
        }

        return targetGrid
    }

    
    func persistData() {
        // The grid now requires exactly `swapsNeeded` swaps to solve
        initialGrid = grid
        
        // Persist the grid and targetGrid for the current level
        userPersistedData.grid = grid
    }
    
    func setupFirstLevel() {
        grid = [
            [.triangle, .triangle, .triangle],
            [.circle, .square, .circle],
            [.square, .circle, .square]
        ]
        
        swipesLeft = 1
        persistData()
    }
    
    func setupLevel(startGrid: [[ShapeType]] = []) {
        if userPersistedData.level == 1 {
            setupFirstLevel()
        }
        (swapsNeeded, shapes) = determineLevelSettings(level: userPersistedData.level)
        swapsMade = []
        undosLeft = 3
        if startGrid.isEmpty {
            grid = generateTargetGrid(from: shapes, with: swapsNeeded)
            showNewLevelAnimation = true
        } else {
            grid = startGrid
        }
        
        swipesLeft = swapsNeeded + 2
        persistData()
    }
    
    func randomAlignedGrid(shapes: [ShapeType]) -> [[ShapeType]] {
        let alignmentIsHorizontal = Bool.random()
        let shuffledShapes = shapes.shuffled()
        let gridSize = shapes.count
        var randomGrid:[[ShapeType]] = []
        if alignmentIsHorizontal {
            // Horizontal alignment
            for shape in shuffledShapes {
                let row = [ShapeType](repeating: shape, count: gridSize)
                randomGrid.append(row)
            }
        } else {
            // Vertical alignment
            randomGrid = Array(repeating: Array(repeating: .circle, count: gridSize), count: gridSize)
            for (colIndex, shape) in shuffledShapes.enumerated() {
                for rowIndex in 0..<gridSize {
                    randomGrid[rowIndex][colIndex] = shape
                }
            }
        }
        
        return randomGrid
    }
    
    func resetLevel() {
        // Reset the grid to its initial configuration
        grid = initialGrid
        swapsMade = []
        undosLeft = 3
        // Reset the swipes left to the initial calculated value
        swipesLeft = swapsNeeded + 2
    }
    
}
