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
        ZStack {
            Color.gray.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture {
                    appModel.resetLevel()
                    appModel.showNoMoreSwipesView = false
                }
            VStack {
                Spacer()
                VStack{
                    Text("0 Swaps ✋")
                        .bold()
                        .font(.system(size: deviceWidth/9))
                        .customTextStroke(width: 2.4)
                        .offset(y: 6)
                    Button {
                        appModel.showGemMenu = true
                    } label: {
                        HStack{
                            Spacer()
                            Text("💎")
                                .bold()
                                .italic()
                                .font(.system(size: deviceWidth/15))
                                .fixedSize()
                                .scaleEffect(1.5)
                                .customTextStroke(width: 1.8)
                            
                            Text("+\(appModel.swapsToSell) Swaps")
                                .bold()
                                .font(.system(size: deviceWidth/12))
                                .customTextStroke(width: 1.8)
                                .lineLimit(1)
                                .fixedSize()
                                .padding(.horizontal, 9)
                            Text("↔️")
                                .bold()
                                .italic()
                                .font(.system(size: deviceWidth/15))
                                .fixedSize()
                                .scaleEffect(1.2)
                                .customTextStroke(width: 1.2)
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
                            Text("🔄")
                                .font(.system(size: deviceWidth/15))
                                .customTextStroke(width: 1.2)
                                .padding(.horizontal)
                        }
                        .padding(.vertical, 14)
                        .frame(width: deviceWidth/3.3)
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
                .padding()
            }
        }
    }
}

#Preview {
    NoMoreSwipesView()
}
