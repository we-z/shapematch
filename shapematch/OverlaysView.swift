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
    var body: some View {
        ZStack {
            if !appModel.firstGamePlayed{
                HandSwipeView()
            }
            if appModel.showGemMenu {
                GemMenuView()
            } else if appModel.showNoMoreSwipesView {
                NoMoreSwipesView()
            }
            InstructionView()
            CelebrationEffect()
        }
    }
}



#Preview {
    OverlaysView()
}
