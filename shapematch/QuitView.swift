//
//  QuitView.swift
//  Shape Swap
//
//  Created by Wheezy Capowdis on 11/8/24.
//

import SwiftUI

struct QuitView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.2)
                .ignoresSafeArea()
            VStack {
                Text("Quit Level?")
                Text("💔")
                Text("Quit")
            }
        }
    }
}

#Preview {
    QuitView()
}
