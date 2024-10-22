//
//  MovesView.swift
//  Shape Swap
//
//  Created by Wheezy Capowdis on 10/4/24.
//

import SwiftUI

struct MovesView: View {
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @State var cardOffset: CGFloat = deviceHeight
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    var body: some View {
        ZStack{
            Color.gray.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    DispatchQueue.main.async { [self] in
                        withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                            cardOffset = deviceWidth * 2
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                                if userPersistedData.hapticsOn {
                                    impactLight.impactOccurred()
                                }
                                appModel.showMovesCard = false
                            }
                        }
                    }
                }
                .gesture(
                    DragGesture()
                        .onEnded { gesture in
                            if gesture.translation.height > 0 {
                                DispatchQueue.main.async { [self] in
                                    withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                                        cardOffset = deviceWidth * 2
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                                            if userPersistedData.hapticsOn {
                                                impactLight.impactOccurred()
                                            }
                                            appModel.showMovesCard = false
                                        }
                                    }
                                }
                            }
                        }
                )
            VStack {
                Spacer()
                VStack {
                    VStack{
                        Capsule()
                            .foregroundColor(.teal)
                            .frame(width: 45, height: 9)
                            .customTextStroke()
                        HStack {
                            Text("How To Play 🧑‍🏫")
                                .bold()
                                .font(.system(size: deviceWidth / 12))
                                .customTextStroke()
                                .padding(.vertical)
                            Spacer()
                        }
                        HStack {
                            Text("Line up the shapes in a\nlimited number of moves 🙇‍♂️")
                                .bold()
                                .font(.system(size: deviceWidth / 21))
                                .customTextStroke(width: 1.2)
                                .multilineTextAlignment(.leading)
                                .fixedSize()
                                .padding(.bottom, 30)
                            Spacer()
                        }
                        HStack {
                            Text("Tip 1️⃣ : If a shape is in the right\nplace, don’t move it 🙅‍♀️")
                                .bold()
                                .font(.system(size: deviceWidth / 21))
                                .customTextStroke(width: 1.2)
                                .multilineTextAlignment(.leading)
                                .fixedSize()
                            Spacer()
                        }
                        HStack {
                            Text("Tip 2️⃣ : Make sure your swaps\nare moving both shapes in there\ncorrect directions 👉")
                                .bold()
                                .font(.system(size: deviceWidth / 21))
                                .customTextStroke(width: 1.2)
                                .multilineTextAlignment(.leading)
                                .fixedSize()
                            Spacer()
                        }
                        .padding(.vertical)
                        HStack {
                            Text("Tip 3️⃣ : Count the number of\nmoves for each shape type and\nstart with the one that requires\nthe most moves 🧠")
                                .bold()
                                .font(.system(size: deviceWidth / 21))
                                .customTextStroke(width: 1.2)
                                .multilineTextAlignment(.leading)
                                .fixedSize()
                            Spacer()
                        }
                        .padding(.bottom, 30)
                    }
                    .padding(30)
                }
                .background{
                    LinearGradient(gradient: Gradient(colors: [.orange, .red]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                }
                .cornerRadius(30)
                .overlay{
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.black, lineWidth: 9)
                        .padding(1)
                }
                .offset(y: cardOffset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            cardOffset = gesture.translation.height
                        }
                        .onEnded { gesture in
                            if gesture.translation.height > 0 {
                                DispatchQueue.main.async { [self] in
                                    withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                                        cardOffset = deviceHeight
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                                            if userPersistedData.hapticsOn {
                                                impactLight.impactOccurred()
                                            }
                                            appModel.showMovesCard = false
                                        }
                                    }
                                }
                            } else {
                                DispatchQueue.main.async { [self] in
                                    withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                                        cardOffset = 0
                                    }
                                }
                            }
                        }
                )
                .padding()
            }
            .onAppear {
                DispatchQueue.main.async {
                    withAnimation(.interpolatingSpring(mass: 2.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                        cardOffset = 0
                    }
                }
            }
        }
    }
    
}

#Preview {
    MovesView()
}
