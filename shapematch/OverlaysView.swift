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
            if userPersistedData.level == 1 && !userPersistedData.firstGamePlayed {
                HandSwipeView()
            }
            InstructionView()
                .padding(idiom == .pad ? 33 : 0)
                .padding(.top, idiom == .pad ? 27 : 0)
            NewGoalView()
                .padding(idiom == .pad ? 33 : 0)
                .padding(.top, idiom == .pad ? 27 : 0)
        }
    }
}



#Preview {
    OverlaysView()
}
