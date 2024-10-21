//
//  ContentView.swift
//  shapematch
//
//  Created by Wheezy Capowdis on 8/17/24.
//

import SwiftUI
import Vortex
struct TempView: View {
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @State var grid: [[ShapeType]] = [
        [.square, .triangle, .circle, .star, .heart], // Updated to 4x4 grid with star shape
        [.triangle, .square, .circle, .star, .heart],
        [.square, .circle, .triangle, .star, .heart],
        [.circle, .triangle, .square, .star, .heart],
        [.circle, .triangle, .square, .star, .heart]
    ]
    
    @State var grid2: [[ShapeType]] = [
        [.square, .triangle, .circle, .star], // Updated to 4x4 grid with star shape
        [.triangle, .square, .circle, .star],
        [.square, .circle, .triangle, .star],
        [.circle, .triangle, .square, .star]
    ]
    
    let emojis = ["🐟", "🐠", "🐡", "🦈", "🐬", "🐳", "🐋", "🐙", "🦑", "🦀", "🦞", "🦐", "🐚", "🪸", "🐊", "🌊", "🏄‍♂️", "🏄‍♀️", "🚤", "🛥️", "⛴️", "🛳️", "🚢", "⛵", "🌅", "🏝️", "🏖️"]
    
    var body: some View {
        ZStack {
            VortexView(createSnow()) {
                ForEach(0...emojis.count - 1, id: \.self) { i in
                    Text(emojis[i])
                        .font(.system(size: deviceWidth/4))
                        .blur(radius: 0)
                        .frame(width: .infinity, height: .infinity)
                        .rotationEffect(.degrees(180))
                        .tag(emojis[i])
                }
            }
            .rotationEffect(.degrees(180))
        }
    }
    
    func createSnow() -> VortexSystem {
        let system = VortexSystem(tags: emojis)
        system.position = [0.5, 0]
        system.speed = 0.1
        system.speedVariation = 0.15
        system.lifespan = 9
        system.shape = .box(width: 9, height: 0)
        system.angle = .degrees(180)
        system.angleRange = .degrees(20)
        system.size = 0.1
        system.sizeVariation = 0.5
        return system
    }
    
}

#Preview {
    TempView()
}
