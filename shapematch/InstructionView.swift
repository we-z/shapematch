//
//  InstructionView.swift
//  Shape Swap
//
//  Created by Wheezy Capowdis on 8/27/24.
//

import SwiftUI

struct InstructionView: View {
    @State var cardOffset: CGFloat = 0
    @ObservedObject private var appModel = AppModel.sharedAppModel
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Text("↘️ Copy the pattern ↙️")
                    .bold()
                    .font(.system(size: deviceWidth / 13))
                    .customTextStroke()
                Spacer()
            }
            .padding(18)
            .background(.blue)
            .cornerRadius(15)
            .overlay{
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black, lineWidth: 6)
                    .padding(1)
            }
            .padding(.horizontal, 6)
            .offset(y: cardOffset)
            
            Spacer()
        }
        .onAppear{
            DispatchQueue.main.async {
                cardOffset = -(deviceWidth/2)
                withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 15.0, initialVelocity: 0.0)) {
                    cardOffset = 0
                }
            }
        }
        .onChange(of: appModel.level) { level in
            if level > 1 {
                DispatchQueue.main.async {
                    withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10.0, initialVelocity: 0.0)) {
                        cardOffset = -(deviceWidth/2)
                    }
                }
            }
        }
        .onChange(of: appModel.showInstruction) { _ in
            if appModel.level < 3 {
                DispatchQueue.main.async {
                    cardOffset = -(deviceWidth/2)
                    withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 15.0, initialVelocity: 0.0)) {
                        cardOffset = 0
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [self] in
                    withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10.0, initialVelocity: 0.0)) {
                        cardOffset = -(deviceWidth/2)
                    }
                }
            }
        }
    }
}
#Preview {
    InstructionView()
}
