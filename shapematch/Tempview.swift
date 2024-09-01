//
//  ContentView.swift
//  shapematch
//
//  Created by Wheezy Capowdis on 8/17/24.
//

import SwiftUI

struct TempView: View {
    
    @State private var grid: [[ShapeType]] = [
        [.square, .triangle, .circle],
        [.triangle, .square, .circle],
        [.square, .circle, .triangle]
    ]
    
    var body: some View {
        ZStack {
            VStack {
                ForEach(0..<3) { row in
                    HStack {
                        ForEach(0..<3) { column in
                            LargeShapeView(shapeType: grid[row][column])
                                .frame(width: deviceWidth / 6, height: deviceWidth / 6)
                                .padding(21)
                        }
                    }
                }
            }
            .scaleEffect(0.9)
        }
    }
    
    func swipeLeft() {
        for row in 0..<3 {
            grid[row] = moveLeft(array: grid[row])
        }
    }
    
    func swipeRight() {
        for row in 0..<3 {
            grid[row] = moveRight(array: grid[row])
        }
    }
    
    func swipeUp() {
        for col in 0..<3 {
            var columnArray = [grid[0][col], grid[1][col], grid[2][col]]
            columnArray = moveLeft(array: columnArray)
            for row in 0..<3 {
                grid[row][col] = columnArray[row]
            }
        }
    }
    
    func swipeDown() {
        for col in 0..<3 {
            var columnArray = [grid[0][col], grid[1][col], grid[2][col]]
            columnArray = moveRight(array: columnArray)
            for row in 0..<3 {
                grid[row][col] = columnArray[row]
            }
        }
    }
    
    func moveLeft(array: [ShapeType]) -> [ShapeType] {
        var newArray = array
        newArray.append(newArray.removeFirst())
        return newArray
    }
    
    func moveRight(array: [ShapeType]) -> [ShapeType] {
        var newArray = array
        newArray.insert(newArray.removeLast(), at: 0)
        return newArray
    }
    
}


#Preview {
    TempView()
}
