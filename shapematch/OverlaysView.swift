//
//  OverlaysView.swift
//  shape match
//
//  Created by Wheezy Capowdis on 8/21/24.
//

import SwiftUI
import AVFoundation

struct OverlaysView: View {
    @ObservedObject var appModel = AppModel.sharedAppModel
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    var body: some View {
        ZStack {
            if userPersistedData.level == 1 {
                HandSwipeView()
            }
            InstructionView()
                .padding(.top, idiom == .pad ? 30 : 0)
            NewGoalView()
                .padding(.top, idiom == .pad ? 30 : 0)
            CelebrationEffect()
            if appModel.showGemMenu {
                GemMenuView()
            } else if appModel.showNoMoreSwipesView {
                NoMoreSwipesView()
            }
            CelebrateGems()
        }
    }
}



#Preview {
    OverlaysView()
}
