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
//    @Published var grid.count = 3
    @Published var swapsNeeded = 1
    @Published var undosLeft = 3
    @Published var amountBought = 5
    @Published var shapes: [ShapeType] = []
    @Published var swapsMade: [(Position, Position)] = []
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
            swipesLeft = swapsNeeded + 2
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
            if userPersistedData.gemBalance >= 300 {
                userPersistedData.decrementBalance(amount: 300)
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

    
    func checkWinCondition() {
        if isWinningGrid(grid: grid) {
            DispatchQueue.main.async { [self] in
                shouldBurst.toggle()
            }
            userPersistedData.firstGamePlayed = true
            if userPersistedData.level == 1 {
                showInstruction.toggle()
            }
            self.freezeGame = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [self] in
                if audioController.musicOn {
                    AudioServicesPlaySystemSound(1320)
                }
                userPersistedData.level += 1
                
                setupLevel()
            }
            // 1335, 1114
            if userPersistedData.soundOn {
                AudioServicesPlaySystemSound(1114)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) { [self] in
                if audioController.musicOn {
                    audioController.musicPlayer.setVolume(1, fadeDuration: 1)
                }
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
        case 2...3:
            swapsNeeded = 2
        case 4...6:
            swapsNeeded = 3
        case 7...10:
            swapsNeeded = 4
        case 11...15:
            swapsNeeded = 5
        case 16...21:
            swapsNeeded = 6
        case 22...28:
            swapsNeeded = 7
        case 29...32:
            swapsNeeded = 4
        case 33...37:
            swapsNeeded = 5
        case 38...43:
            swapsNeeded = 6
        case 44...50:
            swapsNeeded = 7
        case 51...58:
            swapsNeeded = 8
        case 59...67:
            swapsNeeded = 9
        case 68...77:
            swapsNeeded = 10
        case 78...88:
            swapsNeeded = 11
        case 89...100:
            swapsNeeded = 12
        case 101...112:
            swapsNeeded = 13
        case 113...125:
            swapsNeeded = 14
        case 126...140:
            swapsNeeded = 15
        case 141...750:
            swapsNeeded = 16
        case 751...999:
            swapsNeeded = 17
        case 1000...3000:
            swapsNeeded = 18
        case 3001...6000:
            swapsNeeded = 19
        case 6001...9999:
            swapsNeeded = 20
        default:
            swapsNeeded = 21
        }

        
        switch level {
        case 1...28:
            shapes = [.circle, .square, .triangle]
        case 29...141:
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

    
    func persistData() {
        // The grid now requires exactly `swapsNeeded` swaps to solve
        initialGrid = grid
        
        // Persist the grid for the current level
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
        (swapsNeeded, shapes) = determineLevelSettings(level: userPersistedData.level)
        swapsMade = []
        undosLeft = 3
        
        // implement grid shuffle code here
        
        swipesLeft = swapsNeeded + 2
        persistData()
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
