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
            VStack{
                Spacer()
                Text("👆")
                    .rotationEffect(.degrees(-30))
                    .font(.system(size: deviceWidth/3))
                    .customTextStroke()
                    .offset(x: deviceWidth / 9, y: deviceWidth / 6)
                    .animatedOffset(speed: 1.5, distance: deviceWidth/3.3)
            }
            .allowsHitTesting(false)
        }
        VStack{
            Spacer()
            if appModel.showNoMoreSwipesView {
                NoMoreSwipesView()
                    .padding(.bottom)
            }
            if appModel.showLevelDoneView {
                LevelDoneView()
                    .padding(.bottom)
            }
        }
        CelebrationEffect()
    }
}

#Preview {
    OverlaysView()
}
