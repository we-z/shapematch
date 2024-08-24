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
    @CloudStorage("level") var level: Int = 0
    @CloudStorage("lastLaunch") var lastLaunch: String = ""
    @CloudStorage("firstGameEverPlayed") var firstGameEverPlayed: Bool = false
    @CloudStorage("hasSharedShapeSwap") var hasSharedShapeSwap: Bool = false
    
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
