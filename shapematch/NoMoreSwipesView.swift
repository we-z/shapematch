//
//  NoMoreSwipesView.swift
//  shape match
//
//  Created by Wheezy Capowdis on 8/20/24.
//

import SwiftUI

struct NoMoreSwipesView: View {
    
    @ObservedObject private var appModel = AppModel.sharedAppModel
    
    var body: some View {
        VStack{
            Text("✋")
                .font(.system(size: deviceWidth/3))
                .customTextStroke(width: 4)
                .padding(.bottom, 0)
            Text("No more swipes!")
                .bold()
                .font(.system(size: deviceWidth/12 ))
                .customTextStroke(width: 1.8)
            Button {
            } label: {
                HStack{
                    Spacer()
                    Text("Use 1 Gem 💎")
                        .bold()
                        .font(.system(size: deviceWidth/15))
                        .customTextStroke(width: 1.5)
                    Spacer()
                }
                .padding()
                .background(.blue)
                .cornerRadius(15)
                .overlay{
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.black, lineWidth: 4)
                        .padding(1)
                }
                .padding(.horizontal)
            }
            .buttonStyle(.roundedAndShadow6)
            Button {
                appModel.resetLevel()
                appModel.showNoMoreSwipesView = false
            } label: {
                Text("Try again 🔁")
                    .bold()
                    .font(.system(size: deviceWidth/15))
                    .customTextStroke(width: 1.5)
                    .padding()
                    .background(.green)
                    .cornerRadius(15)
                    .overlay{
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black, lineWidth: 4)
                            .padding(1)
                    }
                    .padding()
            }
            .buttonStyle(.roundedAndShadow6)
        }
        .padding()
        .background(.red)
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
    NoMoreSwipesView()
}
