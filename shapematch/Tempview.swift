//
//  ContentView.swift
//  shapematch
//
//  Created by Wheezy Capowdis on 8/17/24.
//

import SwiftUI

struct TempView: View {
    
    @State private var grid: [[ExtendedShapeType]] = [
        [.square, .triangle, .circle, .star], // Updated to 4x4 grid with star shape
        [.triangle, .square, .circle, .star],
        [.square, .circle, .triangle, .star],
        [.circle, .triangle, .square, .star]
    ]
    
    var body: some View {
        ZStack {
            VStack {
                ForEach(0..<4) { row in // Updated to 4 rows
                    HStack {
                        ForEach(0..<4) { column in // Updated to 4 columns
                            ExtendedLargeShapeView(shapeType: grid[row][column])
                                .frame(width: deviceWidth / 6, height: deviceWidth / 6) // Adjusted size for 4x4 grid
                                .padding(15)
                        }
                    }
                }
            }
            .scaleEffect(0.9)
        }
    }
    
    func swipeLeft() {
        for row in 0..<4 {
            grid[row] = moveLeft(array: grid[row])
        }
    }
    
    func swipeRight() {
        for row in 0..<4 {
            grid[row] = moveRight(array: grid[row])
        }
    }
    
    func swipeUp() {
        for col in 0..<4 {
            var columnArray = [grid[0][col], grid[1][col], grid[2][col], grid[3][col]]
            columnArray = moveLeft(array: columnArray)
            for row in 0..<4 {
                grid[row][col] = columnArray[row]
            }
        }
    }
    
    func swipeDown() {
        for col in 0..<4 {
            var columnArray = [grid[0][col], grid[1][col], grid[2][col], grid[3][col]]
            columnArray = moveRight(array: columnArray)
            for row in 0..<4 {
                grid[row][col] = columnArray[row]
            }
        }
    }
    
    func moveLeft(array: [ExtendedShapeType]) -> [ExtendedShapeType] {
        var newArray = array
        newArray.append(newArray.removeFirst())
        return newArray
    }
    
    func moveRight(array: [ExtendedShapeType]) -> [ExtendedShapeType] {
        var newArray = array
        newArray.insert(newArray.removeLast(), at: 0)
        return newArray
    }
}

#Preview {
    TempView()
}
