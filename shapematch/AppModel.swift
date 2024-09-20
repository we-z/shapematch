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
    @Published var undosLeft = 3
    @Published var amountBought = 5
    @Published var shapes: [ShapeType] = []
    @Published var swapsMade: [(Position, Position)] = []
    
    @ObservedObject var audioController = AudioManager.sharedAudioManager
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    
    init() {
        // Initialize the grids from persisted data
        determineLevelSettings()
        
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
        
        swipesLeft = approximateMinimumSwipes(from: grid, to: targetGrid)
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
//        AudioServicesPlaySystemSound(1018)
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
        AudioServicesPlaySystemSound(1104)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            self.swipesLeft -= 1
            swapsMade.append((Position(row: start.row, col: start.col), Position(row: end.row, col: end.col)))
            impactLight.impactOccurred()
            checkWinCondition()
        }
    }
    
    func undoSwap() {
        if !swapsMade.isEmpty {
            undosLeft -= 1
            let lastSwap = swapsMade.removeLast()
            
            AudioServicesPlaySystemSound(1104)
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
                showInstruction.toggle()
                setupLevel()
                swipesLeft = approximateMinimumSwipes(from: grid, to: targetGrid)
                self.freezeGame = false
            }
            AudioServicesPlaySystemSound(1114)
            print("You win!")
        } else if swipesLeft <= 0 {
            AudioServicesPlaySystemSound (1053)
            swapsToSell = approximateMinimumSwipes(from: grid, to: targetGrid)
            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
            showNoMoreSwipesView = true
            print("Level failed")
        }
    }
    
    func determineLevelSettings() {
        // Determine the number of swaps needed based on the level
        switch userPersistedData.level {
        case 1...7:
            swapsNeeded = userPersistedData.level
            case 8...21:
                swapsNeeded = 7
            case 22...35:
                swapsNeeded = 8
            case 36...50:
                swapsNeeded = 9
            case 51...70:
                swapsNeeded = 10
            case 71...100:
                swapsNeeded = 11
            case 101...150:
                swapsNeeded = 12
            case 151...200:
                swapsNeeded = 13
            case 201...300:
                swapsNeeded = 14
            case 301...500:
                swapsNeeded = 15
            case 501...750:
                swapsNeeded = 16
            case 751...999:
                swapsNeeded = 17
            default:
                swapsNeeded = 18
        }

        
        switch userPersistedData.level {
        case 1...50:
            shapes = [.circle, .square, .triangle]
        case 51...999:
            shapes =  [.circle, .square, .triangle, .star]
        default: 
            shapes =  [.circle, .square, .triangle, .star, .hexagon]
        }
        
        offsets = Array(
            repeating: Array(repeating: .zero, count: shapes.count),
            count: shapes.count
        )
    }
    
    func approximateMinimumSwipes(from startGrid: [[ShapeType]], to targetGrid: [[ShapeType]]) -> Int {
        var totalCost = 0
        let shapeTypes = Set(startGrid.flatMap { $0 })
        
        for shapeType in shapeTypes {
            let startPositions = positions(of: shapeType, in: startGrid)
            let targetPositions = positions(of: shapeType, in: targetGrid)
            let cost = minimalTotalMatchingCost(startPositions: startPositions, targetPositions: targetPositions)
            totalCost += cost
        }
        
        // the higher the first number is, the more likely we are to end up with an extra swap
        return Int(floor(Double(totalCost) / 2.0))
    }

    func positions(of shapeType: ShapeType, in grid: [[ShapeType]]) -> [Position] {
        var positions = [Position]()
        for (rowIndex, row) in grid.enumerated() {
            for (colIndex, cell) in row.enumerated() {
                if cell == shapeType {
                    positions.append(Position(row: rowIndex, col: colIndex))
                }
            }
        }
        return positions
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

    func generateTargetGrid(from startGrid: [[ShapeType]], with swapsNeeded: Int) -> [[ShapeType]] {
        
        var targetGrid = startGrid
        var minimumSwapsNeeded = approximateMinimumSwipes(from: startGrid, to: targetGrid)
        var previousMinimumSwapsNeeded = minimumSwapsNeeded
        var iterations = 0
        let maxIterations = 100  // Adjust as needed
        
        while minimumSwapsNeeded < swapsNeeded && iterations < maxIterations {
            iterations += 1
            let gridSize = startGrid.count
            let row = Int.random(in: 0..<gridSize)
            let col = Int.random(in: 0..<gridSize)
            
            var possibleSwaps = [(Int, Int)]()
            if row > 0 { possibleSwaps.append((row - 1, col)) }
            if row < gridSize - 1 { possibleSwaps.append((row + 1, col)) }
            if col > 0 { possibleSwaps.append((row, col - 1)) }
            if col < gridSize - 1 { possibleSwaps.append((row, col + 1)) }
            
            if possibleSwaps.isEmpty { continue }
            
            let (swapRow, swapCol) = possibleSwaps.randomElement()!
            targetGrid.swapAt((row, col), (swapRow, swapCol))
            
            minimumSwapsNeeded = approximateMinimumSwipes(from: startGrid, to: targetGrid)
            
            if minimumSwapsNeeded >= previousMinimumSwapsNeeded {
                previousMinimumSwapsNeeded = minimumSwapsNeeded
            } else {
                targetGrid.swapAt((row, col), (swapRow, swapCol)) // Undo swap
            }
        }
        
        if iterations >= maxIterations {
            print("Could not generate target grid with desired difficulty within iteration limit.")
        }
        
        return targetGrid
    }
    
    func persistData() {
        // The grid now requires exactly `swapsNeeded` swaps to solve
        swipesLeft = approximateMinimumSwipes(from: grid, to: targetGrid)
        initialGrid = grid
        
        // Persist the grid and targetGrid for the current level
        userPersistedData.grid = grid
        userPersistedData.targetGrid = targetGrid
    }
    
    func setupLevel() {
        
        determineLevelSettings()
        swapsMade = []
        undosLeft = 3
        var swapsNeededMet = false
        
        while !swapsNeededMet {
            
            grid = []
            
            for _ in 0..<shapes.count {
                grid.append(shapes.shuffled())
            }
                        
            // optimize
            let generatedTargetGrid = generateTargetGrid(from: grid, with: swapsNeeded)
            
            if swapsNeeded > approximateMinimumSwipes(from: grid, to: generatedTargetGrid) {
                print("trying again")
                
            } else {
                targetGrid = generatedTargetGrid
                swapsNeededMet = true
            }
            
        }
        swipesLeft = approximateMinimumSwipes(from: grid, to: targetGrid)
        persistData()
    }
    
    func resetLevel() {
        // Reset the grid to its initial configuration
        grid = initialGrid
        swapsMade = []
        undosLeft = 3
        // Reset the swipes left to the initial calculated value
        swipesLeft = approximateMinimumSwipes(from: grid, to: targetGrid)
    }
    
}
