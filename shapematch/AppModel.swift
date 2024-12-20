//
//  AppModel.swift
//  shapematch
//
//  Created by Wheezy Capowdis on 8/17/24.
//

import Foundation
import SwiftUI
import AVFoundation
import StoreKit

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
    
    @Published var previewGrid: [[ShapeType]] = [] {
        didSet {
            if previewGrid.count == 3 {
                previewShapeWidth = deviceWidth / 4.0
                previewShapeScale = deviceWidth / 390
            } else if previewGrid.count == 4 {
                previewShapeWidth = deviceWidth / 5.3
                previewShapeScale = deviceWidth / 540
            } else if previewGrid.count == 5 {
                previewShapeWidth = deviceWidth / 6.6
                previewShapeScale = deviceWidth / 690
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
    @Published var shapeWidth = 1.0
    @Published var shapeScale = 1.0
    @Published var previewShapeWidth = 1.0
    @Published var previewShapeScale = 1.0
    @Published var showMovesCard = false
    @Published var showSettings = false
    @Published var showLevelComplete = false
    @Published var showCelebration = false
    @Published var showNewLevelAnimation = false
    @Published var showLivesView = false
    @Published var shouldRewardGem = false
    @Published var showLevelDetails = false
    @Published var showSkinsMenu = false
    @Published var showQuitView = false
    @Published var celebrateLineup = false
    @Published var showLoading = true
    @Published var previewLevel = 0
    @Published var previewMoves = 0
    @Published var swapsNeeded = 1
    @Published var undosLeft = 3
    @Published var amountBought = 5
    @Published var rowsAligned = 0
    @Published var columnsAligned = 0
    @Published var timeTillNextHeart = ""
    @Published var shapes: [ShapeType] = [] {
        didSet {
            self.winningGrids = generateAllWinningGrids(shapes: shapes)
        }
    }
    @Published var previewShapes: [ShapeType] = [] {
        didSet {
            self.winningGrids = generateAllWinningGrids(shapes: previewShapes)
        }
    }
    @Published var swapsMade: [(Position, Position)] = []
    @Published var setupSwaps: [(Position, Position)] = []
    @Published var showSetupSwaps = true
    @Published var winningGrids:[[[ShapeType]]] = []
    @Published var showGame = false
    
    @ObservedObject var audioController = AudioManager.sharedAudioManager
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    
    @Published var skins: [Skin] = [
        Skin(
            SkinID: "shapes",
            cost: 0,
            symbols: [
                .circle: "🔵", .square: "🟩", .triangle: "🔻", .star: "⭐️", .heart: "💜"
            ],
            scaleEffects: [
                .circle: 1.5, .square: 1.5, .triangle: 2.4, .star: 1.7, .heart: 1.6
            ],
            strokeWidths: [
                .circle: 2.1, .square: 2.1, .triangle: 1, .star: 2.1, .heart: 2.1
            ]
        ),
        Skin(
            SkinID: "fruits",
            cost: 10,
            symbols: [
                .circle: "🍎", .square: "🍌", .triangle: "🍊", .star: "🍉", .heart: "🥭"
            ],
            scaleEffects: [
                .circle: 1.5, .square: 1.5, .triangle: 1.5, .star: 1.5, .heart: 1.5
            ],
            strokeWidths: [
                .circle: 1.8, .square: 1.8, .triangle: 1.8, .star: 1.8, .heart: 1.8
            ]
        ),
        Skin(
            SkinID: "animals",
            cost: 30,
            symbols: [
                .circle: "🐶", .square: "🐱", .triangle: "🦊", .star: "🐵", .heart: "🦁"
            ],
            scaleEffects: [
                .circle: 1.5, .square: 1.5, .triangle: 1.5, .star: 1.5, .heart: 1.5
            ],
            strokeWidths: [
                .circle: 1.8, .square: 1.8, .triangle: 1.8, .star: 1.8, .heart: 1.8
            ]
        ),
        Skin(
            SkinID: "sweets",
            cost: 50,
            symbols: [
                .circle: "🍬", .square: "🍭", .triangle: "🧁", .star: "🍩", .heart: "🍡"
            ],
            scaleEffects: [
                .circle: 1.5, .square: 1.5, .triangle: 1.5, .star: 1.5, .heart: 1.5
            ],
            strokeWidths: [
                .circle: 1.8, .square: 1.8, .triangle: 1.8, .star: 1.8, .heart: 1.8
            ]
        ),
        Skin(
            SkinID: "fish",
            cost: 60,
            symbols: [
                .circle: "🐬", .square: "🐠", .triangle: "🐳", .star: "🐙", .heart: "🐡"
            ],
            scaleEffects: [
                .circle: 1.5, .square: 1.5, .triangle: 1.5, .star: 1.5, .heart: 1.5
            ],
            strokeWidths: [
                .circle: 1.8, .square: 1.8, .triangle: 1.8, .star: 1.8, .heart: 1.8
            ]
        ),
        Skin(
            SkinID: "birds",
            cost: 80,
            symbols: [
                .circle: "🕊️", .square: "🦜", .triangle: "🦆", .star: "🦩", .heart: "🦅"
            ],
            scaleEffects: [
                .circle: 1.5, .square: 1.5, .triangle: 1.5, .star: 1.5, .heart: 1.5
            ],
            strokeWidths: [
                .circle: 1.8, .square: 1.8, .triangle: 1.8, .star: 1.8, .heart: 1.8
            ]
        ),
        Skin(
            SkinID: "halloween",
            cost: 100,
            symbols: [
                .circle: "🎃", .square: "👻", .triangle: "🧛‍♂️", .star: "👹", .heart: "🩸"
            ],
            scaleEffects: [
                .circle: 1.5, .square: 1.5, .triangle: 1.5, .star: 1.5, .heart: 1.5
            ],
            strokeWidths: [
                .circle: 2.0, .square: 2.0, .triangle: 2.0, .star: 2.0, .heart: 2.0
            ]
        )
    ]


        // christmas: 🎄🎅❄️⛄️☕️
        
    init() {
        
//        selectedTab = userPersistedData.selectedTab
        // Initialize the grids from persisted data
        (swapsNeeded, shapes) = determineLevelSettings(level: userPersistedData.level)
        startTimer()
        grid = userPersistedData.grid.isEmpty ? [
            [.triangle, .triangle, .triangle],
            [.circle, .square, .circle],
            [.square, .circle, .square]
        ] : userPersistedData.grid
        
        previewGrid = grid
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
    
    let currentTime = NSDate().formatted
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] _ in
            timeTillNextHeart = formatTimeUntilNextRefill()
        }
    }
    
    func formatTimeUntilNextRefill() -> String {
        let now = Date()
//        print("date stored: \(userPersistedData.nextLifeIncrement)")
        guard let nextLifeIncrementDate = ISO8601DateFormatter().date(from: userPersistedData.nextLifeIncrement) else {
            return "Invalid date"
        }

        // Calculate the elapsed time
        if nextLifeIncrementDate <= now {
            let elapsedTime = now.timeIntervalSince(nextLifeIncrementDate)
            
            // Calculate additional lives directly
            let additionalLives = Int(elapsedTime / 1800) + 1 // 30 minutes in seconds
            if additionalLives > 0 {
                // Update the number of lives, capped at 5
                userPersistedData.lives = min(userPersistedData.lives + additionalLives, 5)
                
                // Update nextLifeIncrementDate if lives are not maxed out
                if userPersistedData.lives < 5 {
                    let remainingTime = elapsedTime.truncatingRemainder(dividingBy: 1800)
                    userPersistedData.updateNextLifeIncrement(
                        date: now.addingTimeInterval(1800 - remainingTime).iso8601String()
                    )
                } else {
                    userPersistedData.updateNextLifeIncrement(date: "")
                }
            }
        }


        // Calculate time remaining for the next life
        guard let updatedNextLifeIncrementDate = ISO8601DateFormatter().date(from: userPersistedData.nextLifeIncrement) else {
            return userPersistedData.lives == 5 ? "Full!" : "Calculating..."
        }

        let duration = updatedNextLifeIncrementDate.timeIntervalSince(now)

        let seconds = Int(duration)
        let minutes = (seconds / 60) % 60
        let hours = (seconds / 3600)

        var formattedTime = "⏰ "

        if hours > 0 {
            formattedTime += "\(hours):"
        }

        formattedTime += String(format: "%02d:%02d", minutes, seconds % 60)

        return formattedTime
    }
    
    func checkLivesRenewal() {
        print("currentTime: \(currentTime)")
        
    }
    
    func loseLife() {
        if userPersistedData.lives == 5 {
            
            let futureDate = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
            userPersistedData.updateNextLifeIncrement(date: ISO8601DateFormatter().string(from: futureDate))

        }
        userPersistedData.lives -= 1
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
         
            grid.swapAt((row: start.row, col: start.col), (row: end.row, col: end.col))
            
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
            if !setupSwaps.isEmpty && userPersistedData.level == 2 {
                let lastSwapPos1 = setupSwaps.last!.0
                let lastSwapPos2 = setupSwaps.last!.1
                
                
                if ((lastSwapPos1.col == start.col && lastSwapPos1.row == start.row) && (lastSwapPos2.col == end.col && lastSwapPos2.row == end.row))
                    ||
                    ((lastSwapPos1.col == end.col && lastSwapPos1.row == end.row) && (lastSwapPos2.col == start.col && lastSwapPos2.row == start.row) ) {
                    setupSwaps.removeLast()
                } else {
                    showSetupSwaps = false
                }
                
                
            }
            checkWinCondition()
        }
    }
    
    func hintSwapShapes(start: (row: Int, col: Int), end: (row: Int, col: Int)) {
        print("hintSwapShapes called")
        var offset = CGSize(width: 0, height: 0)
        
        if start.row == end.row {
            // positions are horizontal
            if start.col > end.col {
                offset = CGSize(width: -deviceWidth / (CGFloat(grid.count) * 1.2), height: 0)
            } else {
                offset = CGSize(width: deviceWidth / (CGFloat(grid.count) * 1.2), height: 0)
            }
        }
        
        if start.col == end.col {
            // positions are vertical
            if start.row > end.row {
                offset = CGSize(width: 0, height: -deviceWidth / (CGFloat(grid.count) * 1.2))
            } else {
                offset = CGSize(width: 0, height: deviceWidth / (CGFloat(grid.count) * 1.2))
            }
        }
        
        DispatchQueue.main.async { [self] in
            self.swaping = true
            withAnimation(.linear(duration: 0.2)) {
                offsets[start.row][start.col] = offset
                offsets[end.row][end.col] = CGSize(width: -offset.width, height: -offset.height)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [self] in
            withAnimation(.linear(duration: 0.2)) {
                offsets[start.row][start.col] = .zero
                offsets[end.row][end.col] = .zero
            }
            swaping = false
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
    
    func alignedRows(grid: [[ShapeType]]) -> Int {
        var total = 0
        for row in grid {
            if Set(row).count == 1 {
                total += 1
            }
        }
        return total
    }

    func alignedColumns(grid: [[ShapeType]]) -> Int {
        var total = 0
        let columnCount = grid[0].count
        for col in 0..<columnCount {
            var columnShapes = [ShapeType]()
            for row in grid {
                columnShapes.append(row[col])
            }
            if Set(columnShapes).count == 1 {
                total += 1
            }
        }
        return total
    }
    

    func isWinningGrid(grid: [[ShapeType]]) -> Bool {
        return isAlignedHorizontally(grid: grid) || isAlignedVertically(grid: grid)
    }

    func updateStars() {
        print("updateStars called")
        if swipesLeft > 1 || userPersistedData.level == 1 {
            if let levelStars = userPersistedData.levelStars[String(userPersistedData.level)] {
                if levelStars < 3 {
                    userPersistedData.levelStars[String(userPersistedData.level)] = 3
                    shouldRewardGem = true
                }
            } else {
                userPersistedData.levelStars[String(userPersistedData.level)] = 3
                shouldRewardGem = true
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
            DispatchQueue.main.async { [self] in
                showCelebration = true
            }
            self.showSetupSwaps = false
            userPersistedData.firstGamePlayed = true
            // 1335, 1114
            if userPersistedData.soundOn {
                AudioServicesPlaySystemSound(1114)
            }
            updateStars()
            if userPersistedData.level == userPersistedData.highestLevel {
                userPersistedData.highestLevel += 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                if showGame == true && !showLevelComplete && isWinningGrid(grid: grid) {
                    withAnimation {
                        showLevelComplete = true
                    }
                }
            }
            if userPersistedData.level == 6 {
                if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                    DispatchQueue.main.async {
                        SKStoreReviewController.requestReview(in: scene)
                    }
                }
            }
            print("You win!")
        } else if swipesLeft <= 0 {
            if userPersistedData.level == 1 {
                DispatchQueue.main.async { [self] in
                    setupFirstLevel()
                }
            } else {
                showNoMoreSwipesView = true
            }
            if userPersistedData.soundOn {
                AudioServicesPlaySystemSound (1053)
            }
            if userPersistedData.hapticsOn {
                AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
            }
            print("Level failed")
        } else {
            if alignedRows(grid: grid) > rowsAligned || alignedColumns(grid: grid) > columnsAligned {
                celebrateLineup.toggle()
                print("celebrate line up")
            }
            rowsAligned = alignedRows(grid: grid)
            columnsAligned = alignedColumns(grid: grid)
        }
    }
    
    func determineLevelSettings(level: Int) -> (Int, [ShapeType]) {
        // Determine the number of swaps needed based on the level
        
        var swapsNeeded = 0
        var shapes: [ShapeType] = []
        switch level {
        case 1:
            swapsNeeded = 1
        case 2...5:
            swapsNeeded = 2
        case 5...16:
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
        var swapsMadeToSetup = 0
        var iterations = 0
        let maxIterations = 1000

        while swapsMadeToSetup < swapsNeeded && iterations < maxIterations {
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
                
                if newMinMoves > swapsMadeToSetup {
                    swapMadeOnPosition = true
                    swapsMadeToSetup += 1
                    setupSwaps.append((pos1, pos2))
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
                swapsMadeToSetup = 0
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
        showSetupSwaps = false
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
        if startGrid.isEmpty {
            grid = generateTargetGrid(from: shapes, with: swapsNeeded)
        } else {
            grid = startGrid
        }
        if userPersistedData.level == 2 {
            showSetupSwaps = true
            animateHints()
        } else {
            showSetupSwaps = false
        }
        swipesLeft = swapsNeeded + 2
        rowsAligned = alignedRows(grid: grid)
        columnsAligned = alignedColumns(grid: grid)
        persistData()
    }
    
    func animateHints() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [self] timer in
                if showSetupSwaps {
                    if !setupSwaps.isEmpty {
                        let lastSwap = setupSwaps.last!
                        hintSwapShapes(start: (row: lastSwap.0.row, col: lastSwap.0.col), end: (row: lastSwap.1.row, col: lastSwap.1.col))
                    }
                } else {
                    // Invalidate the timer after bursting 3 times
                    timer.invalidate()
                }
            }
        }
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
        rowsAligned = alignedRows(grid: grid)
        columnsAligned = alignedColumns(grid: grid)
        // Reset the swipes left to the initial calculated value
        swipesLeft = swapsNeeded + 2
    }
    
}
