//
//  OverlaysView.swift
//  shape match
//
//  Created by Wheezy Capowdis on 8/21/24.
//

import SwiftUI
import AVFoundation

struct OverlaysView: View {
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    var body: some View {
        ZStack {
            InstructionView()
                .padding(.top, idiom == .pad ? 30 : 0)
            NewGoalView()
                .padding(.top, idiom == .pad ? 30 : 0)
            CelebrationEffect()
            if !userPersistedData.firstGamePlayed{
                HandSwipeView()
            }
            if appModel.showGemMenu {
                GemMenuView()
            } else if appModel.showNoMoreSwipesView {
                NoMoreSwipesView()
            }
        }
    }
}



#Preview {
    OverlaysView()
}
