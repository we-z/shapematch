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
                        Text("❌")
                            .bold()
                            .font(.system(size: deviceWidth / 12))
                            .customTextStroke(width: 1.5)
                            .padding(.top)
                            .opacity(0)
                        Spacer()
                        Text("Level \(userPersistedData.level)")
                            .bold()
                            .font(.system(size: deviceWidth / 9))
                            .customTextStroke(width: 2.1)
                            .padding(.top)
                        Spacer()
                        Text("❌")
                            .bold()
                            .font(.system(size: deviceWidth / 12))
                            .customTextStroke(width: 1.5)
                            .padding(.top)
                    }
                    .padding(.horizontal, 30)
//                    Text("🥳")
//                        .font(.system(size: deviceWidth / 3))
//                        .customTextStroke(width: 3)
//                        .padding(.bottom, 1)
                    HStack{
                        Text("⭐️")
                        Text("⭐️")
                            .padding(.horizontal)
                        Text("⭐️")
                    }
                    .font(.system(size: deviceWidth / 6))
                    .customTextStroke(width: 2.7)
                    .padding(1)
                    Button {

                    } label: {
                        HStack{
                            Spacer()
                            Text("Continue  ➡️")
                                .italic()
                                .bold()
                                .font(.system(size: deviceWidth/12))
                                .fixedSize()
                                .customTextStroke(width: 1.8)
                            Spacer()
                        }
                        .padding()
                        .background{
                            LinearGradient(gradient: Gradient(colors: [.green, .green]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 0.3))
                        }
                        .cornerRadius(21)
                        .overlay{
                            RoundedRectangle(cornerRadius: 21)
                                .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 5)
                                .padding(1)
                        }
                        .padding(30)
                        
                    }
                    .buttonStyle(.roundedAndShadow6)
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
