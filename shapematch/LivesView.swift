//
//  LivesView.swift
//  Shape Shuffle
//
//  Created by Wheezy Capowdis on 11/14/24.
//

import SwiftUI

struct LivesView: View {
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @State var cardOffset = deviceWidth * 2
    @State var timeLeft = ""
    
    func quit() {
        DispatchQueue.main.async { [self] in
            withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                animateAwayCard()
                if userPersistedData.hapticsOn {
                    impactLight.impactOccurred()
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
            withAnimation() {
                appModel.showNewLivesView = false
                appModel.showGame = false
            }
            appModel.resetLevel()
        }
    }
    
    func animateAwayCard() {
        DispatchQueue.main.async { [self] in
            withAnimation(.linear(duration: 0.3)) {
                cardOffset = deviceWidth * 2
            }
        }
    }
    
    func cancel() {
        if userPersistedData.hapticsOn {
            impactLight.impactOccurred()
        }
        DispatchQueue.main.async { [self] in
            withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                cardOffset = deviceWidth * 2
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
            appModel.showNewLivesView = false
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    cancel()
                }
            VStack {
                Spacer()
                VStack{
                    HStack{
//                       Text("❌")
//                           .bold()
//                           .font(.system(size: deviceWidth / 12))
//                           .customTextStroke(width: 1.5)
//                           .fixedSize()
//                           .padding(.top)
//                           .opacity(0)
                       Spacer()
                       Text("More Lives!")
                           .bold()
                           .font(.system(size: deviceWidth / 12))
                           .customTextStroke(width: 2.1)
                           .fixedSize()
                           .padding(.top)
                       Spacer()
//                       Button {
//                           cancel()
//                       } label: {
//                           Text("❌")
//                               .bold()
//                               .font(.system(size: deviceWidth / 12))
//                               .customTextStroke(width: 1.8)
//                               .fixedSize()
//                               .padding(.top)
//                       }
                   }
                   .padding(.horizontal, 36)
                   .padding(.top)
                   .zIndex(1)
                    ZStack {
                        RotatingSunView()
                            .frame(width: 1, height: 1)
                        Text("❤️")
                            .font(.system(size: deviceWidth / 4))
                            .customTextStroke(width: 2.7)
                    }
                    .zIndex(0)
                    Text("Time to next life:")
                        .bold()
                        .font(.system(size: deviceWidth / 15))
                        .customTextStroke(width: 1.8)
                        .fixedSize()
                    Text(timeLeft)
                        .bold()
                        .font(.system(size: deviceWidth / 15))
                        .customTextStroke(width: 1.8)
                        .fixedSize()
                    Button {
                        quit()
                    } label: {
                        HStack{
                            Text("Refill")
                                .bold()
                                .font(.system(size: deviceWidth/9))
                                .fixedSize()
                                .customTextStroke(width: 2.4)
                            Spacer()
                            Text("💎 9")
                                .bold()
                                .font(.system(size: deviceWidth/9))
                                .fixedSize()
                                .customTextStroke(width: 2.4)
                        }
                        .padding()
                        .padding(.horizontal)
                        .background{
                            LinearGradient(gradient: Gradient(colors: [.teal, .blue]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                        }
                        .cornerRadius(27)
                        .overlay{
                            RoundedRectangle(cornerRadius: 27)
                                .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 5)
                                .padding(1)
                        }
                        .padding([.horizontal, .bottom], idiom == .pad ? 60 : 45)
                        
                    }
                    .buttonStyle(.roundedAndShadow6)
                    .shadow(color: .blue, radius: 6)
                }
                .background{
                    LinearGradient(gradient: Gradient(colors: [.red, .black]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                }
                .cornerRadius(39)
                .overlay {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.yellow, lineWidth: idiom == .pad ? 12 : 9)
                        .padding(1)
                        .shadow(radius: 3)
                        .padding()
                }
                .shadow(radius: 3)
                .padding()
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
                                        cancel()
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
            }
        }
        .onAppear {
            DispatchQueue.main.async { [self] in
                withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 24.0, initialVelocity: 0.0)) {
                    cardOffset = 0
                }
            }
        }
    }
}

#Preview {
    LivesView()
}
