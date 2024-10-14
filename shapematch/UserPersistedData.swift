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
    
    @CloudStorage("gemBalance") var gemBalance: Int = 1000
    @CloudStorage("firstGamePlayed") var firstGamePlayed: Bool = false
    @CloudStorage("hasShared") var hasShared: Bool = false
    @CloudStorage("soundOn") var soundOn: Bool = true
    @CloudStorage("hapticsOn") var hapticsOn: Bool = true
    @CloudStorage("gridData") var gridData: String = ""
    @CloudStorage("targetGridData") var targetGridData: String = ""
    @CloudStorage("highestLevel") var highestLevel: Int = 0
    @CloudStorage(wrappedValue: "{}", "levelStars") var levelStarsString: String
    @CloudStorage("selectedTab") var selectedTab = 1
    @CloudStorage("level") var level: Int = 1 {
        didSet {
            if level > highestLevel {
                highestLevel = level
            }
        }
    }
    
    var levelStars: [Int: Int] {
        get {
            stringToDictionary(levelStarsString)
        }
        set {
            levelStarsString = dictionaryToString(newValue)
        }
    }

//    @Published var gemBalance: Int = 0
//    @Published var firstGamePlayed: Bool = false
//    @Published var hasShared: Bool = false
//    @Published var showedMovesCard: Bool = false
//    @Published var gridData: String = ""
//    @Published var targetGridData: String = ""
//    @Published var highestLevel: Int = 0
//    @Published var level: Int = 16 {
//        didSet {
//            if level > highestLevel {
//                highestLevel = level
//            }
//        }
//    }
//
//    @CloudStorage("lastLaunch") var lastLaunch: String = ""
    
    init() {
        highestLevel = highestLevel == 1 ? level : highestLevel
    }
    
    // Helper functions to serialize and deserialize
    func dictionaryToString(_ dictionary: [Int: Int]) -> String {
        if let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: []) {
            return String(data: jsonData, encoding: .utf8) ?? "{}"
        }
        return "{}"
    }

    func stringToDictionary(_ string: String) -> [Int: Int] {
        if let jsonData = string.data(using: .utf8),
           let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [Int: Int] {
            return dictionary
        }
        return [:]
    }

    
    var grid: [[ShapeType]] {
        get { decodeGrid(from: gridData) }
        set { gridData = encodeGrid(newValue) }
    }

    var targetGrid: [[ShapeType]] {
        get { decodeGrid(from: targetGridData) }
        set { targetGridData = encodeGrid(newValue) }
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
