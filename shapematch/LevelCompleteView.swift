//
//  LevelCompleteView.swift
//  Shape Swap
//
//  Created by Wheezy Capowdis on 10/11/24.
//

import SwiftUI

struct LevelCompleteView: View {
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    var body: some View {
        VStack{
            Spacer()
                
                VStack{
                    HStack{
                        Spacer()
                        Text("Level \(userPersistedData.level)")
                            .bold()
                            .font(.system(size: deviceWidth / 9))
                            .customTextStroke(width: 3)
                            .padding()
                        Spacer()
                    }
                }
                .background{
                    Color.white
                    Color.blue.opacity(0.6)
                }
                .cornerRadius(30)
                .overlay {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.yellow, lineWidth: idiom == .pad ? 11 : 6)
                        .padding(1)
                        .shadow(radius: 3)
                }
                .shadow(radius: 3)
                .padding()
        }
    }
}

#Preview {
    LevelCompleteView()
}
