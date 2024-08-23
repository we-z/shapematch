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
                Text("❌")
                    .font(.system(size: deviceWidth/15))
                    .customTextStroke()
                    .padding([.trailing, .top], 21)
            }
            Text("💎 Gems 💎")
                .bold()
                .font(.system(size: deviceWidth/8))
                .customTextStroke()
                
//            Spacer()
            VStack(spacing: 21) {
                Button {
                } label: {
                    HStack{
                        Text("💎")
                            .bold()
                            .italic()
                            .font(.system(size: deviceWidth/15))
                            .fixedSize()
                            .scaleEffect(1.5)
                            .customTextStroke()
                            .padding(12)
                        Text("10")
                            .bold()
                            .font(.system(size: deviceWidth/12))
                            .customTextStroke(width: 1.5)
                        Spacer()
                        Text("$1.99")
                            .font(.system(size: deviceWidth/21))
                            .customTextStroke(width:1.2)
                            .padding(9)
                            .background(.green)
                            .cornerRadius(15)
                            .overlay{
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.black, lineWidth: 3)
                                    .padding(1)
                            }
                            .padding(.trailing, 3)
                    }
                    .padding()
                    .background(.blue)
                    .cornerRadius(15)
                    .overlay{
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black, lineWidth: 4)
                            .padding(1)
                    }
                    .padding(.horizontal, 30)
                }
                .buttonStyle(.roundedAndShadow6)
                Button {
                } label: {
                    HStack{
                        Text("💎")
                            .bold()
                            .italic()
                            .font(.system(size: deviceWidth/15))
                            .fixedSize()
                            .scaleEffect(1.5)
                            .customTextStroke()
                            .padding(12)
                        Text("100")
                            .bold()
                            .font(.system(size: deviceWidth/12))
                            .customTextStroke(width: 1.5)
                            
                        Spacer()
                        Text("$14.99")
                            .font(.system(size: deviceWidth/21))
                            .customTextStroke(width:1.2)
                            .padding(9)
                            .background(.green)
                            .cornerRadius(15)
                            .overlay{
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.black, lineWidth: 3)
                                    .padding(1)
                            }
                            .padding(.trailing, 3)
                    }
                    .padding()
                    .background(.blue)
                    .cornerRadius(15)
                    .overlay{
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black, lineWidth: 4)
                            .padding(1)
                    }
                    .padding(.horizontal, 30)
                }
                .buttonStyle(.roundedAndShadow6)
                Button {
                } label: {
                    HStack{
                        Text("💎")
                            .bold()
                            .italic()
                            .font(.system(size: deviceWidth/15))
                            .fixedSize()
                            .scaleEffect(1.5)
                            .customTextStroke()
                            .padding(12)
                        Text("1000")
                            .bold()
                            .font(.system(size: deviceWidth/12))
                            .customTextStroke(width: 1.5)

                        Spacer()
                        Text("$99.99")
                            .font(.system(size: deviceWidth/21))
                            .customTextStroke(width:1.2)
                            .padding(9)
                            .background(.green)
                            .cornerRadius(15)
                            .overlay{
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.black, lineWidth: 3)
                                    .padding(1)
                            }
                            .padding(.trailing, 3)
                    }
                    .padding()
                    .background(.blue)
                    .cornerRadius(15)
                    .overlay{
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black, lineWidth: 4)
                            .padding(1)
                    }
                    .padding(.horizontal, 30)
                }
                .buttonStyle(.roundedAndShadow6)
            }
            .padding(.bottom, 30)
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
