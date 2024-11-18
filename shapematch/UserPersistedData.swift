//
//  UserPersistedData.swift
//  Shape Swap
//
//  Created by Wheezy Capowdis on 8/24/24.
//


import Foundation
import CloudStorage

class UserPersistedData: ObservableObject {
    static let sharedUserPersistedData = UserPersistedData()
    
    @CloudStorage("gemBalance") var gemBalance: Int = 5
    @CloudStorage("chosenSkin") var chosenSkin: String = "shapes"
    @CloudStorage("purchasedSkins") var purchasedSkins: String = "shapes,"
    @CloudStorage("firstGamePlayed") var firstGamePlayed: Bool = false
    @CloudStorage("hasShared") var hasShared: Bool = false
    @CloudStorage("soundOn") var soundOn: Bool = true
    @CloudStorage("hapticsOn") var hapticsOn: Bool = true
    @CloudStorage("gridData") var gridData: String = ""
    @CloudStorage("highestLevel") var highestLevel: Int = 1
    @CloudStorage("lives") var lives: Int = 5
    @CloudStorage("nextLifeIncrement") var nextLifeIncrement: String = ""
    @CloudStorage(wrappedValue: "{}", "levelStars") var levelStarsString: String
    @CloudStorage("level") var level: Int = 1 {
        didSet {
            if level > highestLevel {
                highestLevel = level
            }
        }
    }
    
    func updateNextLifeIncrement(date: String) {
        nextLifeIncrement = date
    }
    
    var levelStars: [String: Int] {
        get {
            stringToDictionary(levelStarsString)
        }
        set {
            levelStarsString = dictionaryToString(newValue)
        }
    }
    
    init() {
        highestLevel = highestLevel == 1 ? level : highestLevel
    }
    
    // Helper functions to serialize and deserialize
    func dictionaryToString(_ dictionary: [String: Int]) -> String {
        if let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: []) {
            return String(data: jsonData, encoding: .utf8) ?? "{}"
        }
        return "{}"
    }

    func stringToDictionary(_ string: String) -> [String: Int] {
        if let jsonData = string.data(using: .utf8),
           let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Int] {
            return dictionary
        }
        return [:]
    }

    
    var grid: [[ShapeType]] {
        get { decodeGrid(from: gridData) }
        set { gridData = encodeGrid(newValue) }
    }
    
    private func encodeGrid(_ grid: [[ShapeType]]) -> String {
        let flatGrid = grid.flatMap { $0.map { "\($0.rawValue)" } }
        return flatGrid.joined(separator: ",")
    }

    private func decodeGrid(from string: String) -> [[ShapeType]] {
        let flatGrid = string.split(separator: ",").compactMap { Int($0).flatMap(ShapeType.init) }
        var chunks = 3
        switch flatGrid.count {
        case 9:
            chunks = 3
        case 16:
            chunks = 4
        case 25:
            chunks = 5
        default:
            chunks = 3
        }
        return Array(flatGrid.chunked(into: chunks))
    }
    
    func incrementBalance(amount: Int) {
        gemBalance += amount
    }
    
    func decrementBalance(amount: Int) {
        gemBalance -= amount
    }
    
//    func updateLastLaunch(date: String) {
//        lastLaunch = date
//    }

}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
