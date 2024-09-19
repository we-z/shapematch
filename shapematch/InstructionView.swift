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
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    var body: some View {
        VStack{
            HStack{
                Spacer()
                VStack(spacing: 5){
                    Text("↘️ Match the goal pattern ↙️")
                        .bold()
                        .multilineTextAlignment(.center)
                        .font(.system(size: deviceWidth / 15))
                        .customTextStroke(width: 1.8)
                }
                Spacer()
            }
            .padding(.vertical, 21)
            .background(.blue)
            .cornerRadius(15)
            .overlay{
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 6)
                    .padding(1)
            }
            .padding(.horizontal, 12)
            .offset(y: cardOffset)
            
            Spacer()
        }
        .gesture(
            DragGesture(minimumDistance: 1, coordinateSpace: .local)
                .onEnded { value in
                    if value.translation.height < 0 {
                        // Swipe up detected
                        DispatchQueue.main.async { [self] in
                            withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10.0, initialVelocity: 0.0)) {
                                cardOffset = -(deviceWidth/2)
                            }
                        }
                    }
                }
        )
        .onChange(of: userPersistedData.firstGamePlayed) { firstGamePlayed in
            if firstGamePlayed {
                DispatchQueue.main.async {
                    withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10.0, initialVelocity: 0.0)) {
                        cardOffset = -(deviceWidth/2)
                    }
                }
            }
        }
        .onChange(of: appModel.showInstruction) { _ in
            if userPersistedData.level < 3 {
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
        .onAppear {
            if userPersistedData.level > 1 {
                cardOffset = -(deviceWidth/2)
            }
        }
    }
}

struct NewGoalView: View {
    @State var cardOffset: CGFloat = -(deviceWidth/2)
    @ObservedObject private var appModel = AppModel.sharedAppModel
    var body: some View {
        VStack{
            HStack{
                Spacer()
                VStack(spacing: 5){
                    Text("↘️ New goal pattern ↙️")
                        .bold()
                        .multilineTextAlignment(.center)
                        .font(.system(size: deviceWidth / 12))
                        .customTextStroke(width: 1.8)
                }
                Spacer()
            }
            .padding(.vertical, 18)
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
        .gesture(
            DragGesture(minimumDistance: 1, coordinateSpace: .local)
                .onEnded { value in
                    if value.translation.height < 0 {
                        // Swipe up detected
                        DispatchQueue.main.async { [self] in
                            withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10.0, initialVelocity: 0.0)) {
                                cardOffset = -(deviceWidth/2)
                            }
                        }
                    }
                }
        )
        .onChange(of: appModel.showNewGoal) { _ in
            DispatchQueue.main.async {
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

#Preview {
    InstructionView()
}
