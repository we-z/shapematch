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
                    Text("💎 + \(appModel.initialSwipes) swipes")
                        .italic()
                        .bold()
                        .font(.system(size: deviceWidth/15))
                        .customTextStroke(width: 1.8)
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
                HStack{
                    Image(systemName: "arrow.counterclockwise")
                        .customTextStroke(width: 1.5)
                        .font(.system(size: deviceWidth/18))
                        .padding(.horizontal)
                }
                .padding(.horizontal, 21)
                .padding(.vertical, 6)
                .frame(height: deviceWidth/6.3)
                .background{
                    Color.red
                }
                .cornerRadius(15)
                .overlay{
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.black, lineWidth: 4)
                        .padding(1)
                }
            }
            .buttonStyle(.roundedAndShadow6)
            .padding(.vertical)
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
