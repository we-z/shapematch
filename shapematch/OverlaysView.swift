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
            if userPersistedData.level == 1 && !appModel.freezeGame {
                HandSwipeView()
                    .scaleEffect(idiom == .pad ? 0.8 : 1)
            }
        }
    }
}



#Preview {
    OverlaysView()
}
