//
//  LevelDoneView.swift
//  shape match
//
//  Created by Wheezy Capowdis on 8/20/24.
//

import SwiftUI

struct LevelDoneView: View {
    @ObservedObject private var appModel = AppModel.sharedAppModel
    
    var body: some View {
        VStack{
            Text("✅")
                .font(.system(size: deviceWidth/3))
                .customTextStroke(width: 4)
            Text("LEVEL \(appModel.level)\n🎉 COMPLETE 🎊")
                .multilineTextAlignment(.center)
                .italic()
                .bold()
                .font(.system(size: deviceWidth/12))
                .customTextStroke(width: 2.1)
            Button {
                appModel.level += 1
                appModel.setupLevel()
                appModel.swipesLeft =  appModel.calculateMinimumSwipes(from:  appModel.grid, to:  appModel.targetGrid)
            } label: {
                HStack{
                    Spacer()
                    Text("GO LEVEL \(appModel.level + 1) ➡️")
                        .italic()
                        .bold()
                        .font(.system(size: deviceWidth/12))
                        .customTextStroke(width: 2.1)
                    Spacer()
                }
                .padding()
                .background(.green)
                .cornerRadius(15)
                .overlay{
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.black, lineWidth: 4)
                        .padding(1)
                }
                .padding([.bottom, .horizontal])
            }
            .buttonStyle(.roundedAndShadow6)
        }
        .padding()
        .background(.blue)
        .cornerRadius(30)
        .overlay{
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.black, lineWidth: 7)
                .padding(1)
        }
        .padding(.horizontal)
    }
}

#Preview {
    LevelDoneView()
}
