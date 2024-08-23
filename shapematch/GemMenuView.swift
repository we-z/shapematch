//
//  GemMenuView.swift
//  Shape Shuffle
//
//  Created by Wheezy Capowdis on 8/22/24.
//

import SwiftUI

struct GemMenuView: View {
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Text("💎 Gems 💎")
                    .bold()
                    .font(.system(size: deviceWidth/8))
                    .customTextStroke()
                    .padding(30)
                Spacer()
            }
            Spacer()
        }
        .background(.blue)
        .cornerRadius(30)
        .overlay{
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.black, lineWidth: 9)
                .padding(1)
        }
        .padding()
        
    }
}

#Preview {
    GemMenuView()
}
