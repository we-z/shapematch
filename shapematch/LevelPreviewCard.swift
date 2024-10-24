//
//  LevelPreviewCard.swift
//  Shape Swap
//
//  Created by Wheezy Capowdis on 10/24/24.
//

import SwiftUI

struct LevelPreviewCard: View {
    @ObservedObject var appModel = AppModel.sharedAppModel
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    
    @State var cardOffset: CGFloat = deviceHeight
    
    func animateAwayButtonsAndBanner() {
        DispatchQueue.main.async { [self] in
            withAnimation(.linear(duration: 0.3)) {
                cardOffset = deviceWidth * 3
            }
        }
    }
    
    var body: some View {
        ZStack{
            Color.gray.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    DispatchQueue.main.async { [self] in
                        withAnimation(.interpolatingSpring(mass: 6.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                            cardOffset = deviceWidth * 3
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                                if userPersistedData.hapticsOn {
                                    impactLight.impactOccurred()
                                }
                                appModel.showLevelDetails = false
                            }
                        }
                    }
                }
                .gesture(
                    DragGesture()
                        .onEnded { gesture in
                            if gesture.translation.height > 0 {
                                DispatchQueue.main.async { [self] in
                                    withAnimation(.interpolatingSpring(mass: 6.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                                        cardOffset = deviceWidth * 3
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                                            if userPersistedData.hapticsOn {
                                                impactLight.impactOccurred()
                                            }
                                            appModel.showLevelDetails = false
                                        }
                                    }
                                }
                            }
                        }
                )
            VStack{
                Spacer()
                ZStack {
                    VStack(spacing: 0){
                        Capsule()
                            .overlay {
                                ZStack{
                                    Color.teal
                                }
                            }
                            .frame(width: 45, height: 9)
                            .cornerRadius(15)
                            .padding()
                            .customTextStroke()
                        HStack {
                            Spacer()
                            Text("Level: \(appModel.previewLevel)")
                                .bold()
                                .font(.system(size: deviceWidth/15))
                                .fixedSize()
                                .customTextStroke(width: 1.5)
                            Spacer()
                            Text("Moves: \(appModel.previewMoves + 2)")
                                .bold()
                                .multilineTextAlignment(.center)
                                .font(.system(size: deviceWidth/15))
                                .fixedSize()
                                .customTextStroke(width: 1.5)
                            Spacer()
                        }
                        VStack{
                            VStack{
                                ForEach(0..<appModel.previewShapes.count, id: \.self) { row in
                                    HStack {
                                        ForEach(0..<appModel.previewShapes.count, id: \.self) { column in
                                            ShapeView(shapeType: appModel.previewGrid[row][column])
                                                .frame(width: appModel.previewShapeWidth / 1.2, height: appModel.previewShapeWidth / 1.2)
                                                .scaleEffect( appModel.previewShapeScale / 1.2)
                                                .scaleEffect(idiom == .pad ? 0.55 : 1)
                                        }
                                    }
                                }
                            }
                        }
                        .padding( idiom == .pad ? 30 : 18)
                        .background{
                            ZStack{
                                Color.white
                                Color.blue.opacity(0.6)
                            }
                        }
                        .cornerRadius(idiom == .pad ? 30 : 18)
                        .overlay {
                            RoundedRectangle(cornerRadius: idiom == .pad ? 30 : 18)
                                .stroke(Color.yellow, lineWidth: idiom == .pad ? 9 : 7)
                                .padding(1)
                                .shadow(radius: 3)
                        }
                        .shadow(radius: 3)
                        .padding(.vertical)
                        if appModel.previewLevel <= userPersistedData.highestLevel {
                            Button {
                                animateAwayButtonsAndBanner()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                                    userPersistedData.level = appModel.previewLevel
                                    appModel.setupLevel(startGrid: appModel.previewGrid)
                                    withAnimation {
                                        appModel.selectedTab = 1
                                        appModel.showLevelDetails = false
                                    }
                                    appModel.showNewLevelAnimation = true
                                }
                            } label: {
                                HStack{
                                    Spacer()
                                    Text("Play!  ➡️")
                                        .italic()
                                        .bold()
                                        .font(.system(size: deviceWidth/12))
                                        .fixedSize()
                                        .customTextStroke(width: 2.1)
                                    Spacer()
                                }
                                .padding()
                                .background{
                                    LinearGradient(gradient: Gradient(colors: [.mint, .green]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 0.5))
                                }
                                .cornerRadius(idiom == .pad ? 39: 21)
                                .overlay{
                                    RoundedRectangle(cornerRadius: idiom == .pad ? 39 : 21)
                                        .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 5)
                                        .padding(1)
                                }
                                .padding()
                                .padding(idiom == .pad ? 30 : 0)
                                
                            }
                            .buttonStyle(.roundedAndShadow6)
                        }
                    }
                }
                .padding()
                .background{
                    LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                }
                .cornerRadius(30)
                .overlay{
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.black, lineWidth: 9)
                        .padding(1)
                }
                .padding()
//                .scaleEffect(idiom == .pad ? 0.6 : 1)
                .offset(y: cardOffset)
                .onAppear{
                    DispatchQueue.main.async {
                        cardOffset = deviceHeight
                        withAnimation(.interpolatingSpring(mass: 6.0, stiffness: 100.0, damping: 30.0, initialVelocity: 0.0)) {
                            cardOffset = 0
                        }
                    }
                }
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            cardOffset = gesture.translation.height
                        }
                        .onEnded { gesture in
                            if gesture.translation.height > 0 {
                                DispatchQueue.main.async { [self] in
                                    withAnimation(.interpolatingSpring(mass: 6.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                                        cardOffset = deviceWidth * 3
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                                            if userPersistedData.hapticsOn {
                                                impactLight.impactOccurred()
                                            }
                                            appModel.showLevelDetails = false
                                        }
                                    }
                                }
                            } else {
                                DispatchQueue.main.async { [self] in
                                    withAnimation(.interpolatingSpring(mass: 6.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                                        cardOffset = 0
                                    }
                                }
                            }
                        }
                )
            }
        }
    }
}

#Preview {
    LevelPreviewCard()
}
