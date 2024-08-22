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
        ZStack {
            if appModel.showLevelDoneView || appModel.showNoMoreSwipesView {
                Color.gray.opacity(0.7)
                    .ignoresSafeArea()
            }
            HandSwipeView()
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
}

#Preview {
    OverlaysView()
}
