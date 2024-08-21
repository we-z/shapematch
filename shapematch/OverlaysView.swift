//
//  OverlaysView.swift
//  shape match
//
//  Created by Wheezy Capowdis on 8/21/24.
//

import SwiftUI

struct OverlaysView: View {
    @ObservedObject private var appModel = AppModel.sharedAppModel
    var body: some View {
        if appModel.showLevelDoneView || appModel.showNoMoreSwipesView {
            Color.gray.opacity(0.7)
                .ignoresSafeArea()
        }
        if !appModel.firstGamePlayed {
            Color.gray.opacity(0.7)
                .reverseMask{
                    VStack{
                        Spacer()
                        Rectangle()
                            .frame(width: deviceWidth/3, height: deviceWidth/1.5)
                            .cornerRadius(30)
                            .padding()
                    }
                }
                .ignoresSafeArea()
                .allowsHitTesting(false)
            VStack{
                Spacer()
                Text("👆")
                    .font(.system(size: deviceWidth/5))
                    .customTextStroke()
                    .offset(x: deviceWidth / 30, y: deviceWidth / 9)
                    .animatedOffset(speed: 1.5, distance: deviceWidth/2.4)
            }
            .allowsHitTesting(false)
        }
        VStack{
            Spacer()
            if appModel.showNoMoreSwipesView {
                NoMoreSwipesView()
            }
            if appModel.showLevelDoneView {
                LevelDoneView()
            }
        }
        CelebrationEffect()
    }
}

#Preview {
    OverlaysView()
}
