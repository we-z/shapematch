//
//  UserPersistedData.swift
//  Shape Swap
//
//  Created by Wheezy Capowdis on 8/24/24.
//


import Foundation
import CloudStorage

class UserPersistedData: ObservableObject {
    @CloudStorage("gemBalance") var gemBalance: Int = 0
    @CloudStorage("leveltest3") var level: Int = 1
    @CloudStorage("lastLaunch") var lastLaunch: String = ""
    @CloudStorage("firstGamePlayedtest") var firstGamePlayed: Bool = false
    @CloudStorage("hasSharedShapeSwap") var hasSharedShapeSwap: Bool = false
    
    @CloudStorage("gridDatatest") var gridData: String = ""
    @CloudStorage("targetGridDatatest") var targetGridData: String = ""
    
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
        return Array(flatGrid.chunked(into: 3))
    }
    
    func incrementBalance(amount: Int) {
        gemBalance += amount
    }
    
    func decrementBalance(amount: Int) {
        gemBalance -= amount
    }
    
    func updateLastLaunch(date: String) {
        lastLaunch = date
    }

}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
