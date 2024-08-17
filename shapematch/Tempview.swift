//
//  ContentView.swift
//  shapematch
//
//  Created by Wheezy Capowdis on 8/17/24.
//

import SwiftUI

struct TempView: View {
    @State private var grid: [[ShapeType]] = [
        [.circle, .circle, .circle],
        [.square, .square, .square],
        [.triangle, .triangle, .triangle]
    ]
    
    let targetGrid: [[ShapeType]] = [
        [.circle, .circle, .circle],
        [.square, .square, .square],
        [.triangle, .triangle, .triangle]
    ]
    
    var body: some View {
        VStack {
            ForEach(0..<3) { row in
                HStack {
                    ForEach(0..<3) { column in
                        ShapeView(shapeType: grid[row][column])
                            .frame(width: deviceWidth / 4.5, height: deviceWidth / 4.5)
                            .padding()
                    }
                }
            }
        }
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if abs(gesture.translation.width) > abs(gesture.translation.height) {
                        if gesture.translation.width < 0 {
                            swipeLeft()
                        } else {
                            swipeRight()
                        }
                    } else {
                        if gesture.translation.height < 0 {
                            swipeUp()
                        } else {
                            swipeDown()
                        }
                    }
                    checkWinCondition()
                }
        )
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
    
    func checkWinCondition() {
        if grid == targetGrid {
            print("You win!")
        }
    }
}


#Preview {
    TempView()
}
