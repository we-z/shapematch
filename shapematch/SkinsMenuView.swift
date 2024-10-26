//
//  SkinsMenuView.swift
//  Shape Swap
//
//  Created by Wheezy Capowdis on 10/25/24.
//

import SwiftUI

struct SkinsMenuView: View {
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
                                appModel.showSkinsMenu = false
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
                                            appModel.showSkinsMenu = false
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
                            .foregroundColor(.red)
                            .frame(width: 45, height: 9)
                            .customTextStroke()
                        HStack {
                            Text("🍎  Skins  🦊")
                                .bold()
                                .font(.system(size: deviceWidth / 12))
                                .customTextStroke()
                                .padding(.vertical)
                        }
                        
                        Button {
                        } label: {
                            HStack {
                                
                                ForEach(ShapeType.allCases) { shape in
                                    ShapesView(shapeType: shape)
                                        .frame(width: deviceWidth / 15, height: deviceWidth / 15)
                                        .scaleEffect(0.3)
                                        .fixedSize()
                                }

                                
                                Spacer()
                                Text("✅")
                                    .bold()
                                    .font(.system(size: deviceWidth / 15))
                                    .customTextStroke(width: 1.8)
                                    .multilineTextAlignment(.leading)
                                    .fixedSize()
                            }
                            .padding()
                            .background{
                                LinearGradient(gradient: Gradient(colors: [.yellow, .orange]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                            }
                            .cornerRadius(15)
                            .overlay{
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 5)
                                    .padding(1)
                            }
                            .padding(.bottom)
                        }
                        .buttonStyle(.roundedAndShadow6)
                        
                        Button {
                        } label: {
                            HStack {
                                Text("🍎 🍌 🍊 🍉 🥭")
                                    .bold()
                                    .font(.system(size: deviceWidth / 15))
                                    .customTextStroke(width: 1.8)
                                    .multilineTextAlignment(.leading)
                                    .fixedSize()
                                Spacer()
                                Text("💎 10")
                                    .bold()
                                    .font(.system(size: deviceWidth / 21))
                                    .customTextStroke(width: 1.5)
                                    .multilineTextAlignment(.leading)
                                    .fixedSize()
                            }
                            .padding()
                            .background{
                                LinearGradient(gradient: Gradient(colors: [.yellow, .orange]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                            }
                            .cornerRadius(15)
                            .overlay{
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 5)
                                    .padding(1)
                            }
                            .padding(.bottom)
                        }
                        .buttonStyle(.roundedAndShadow6)
                        
                        Button {
                        } label: {
                            HStack {
                                Text("🐶 😺 🦊 🐵 🦁")
                                    .bold()
                                    .font(.system(size: deviceWidth / 15))
                                    .customTextStroke(width: 1.8)
                                    .multilineTextAlignment(.leading)
                                    .fixedSize()
                                Spacer()
                                Text("💎 30")
                                    .bold()
                                    .font(.system(size: deviceWidth / 21))
                                    .customTextStroke(width: 1.5)
                                    .multilineTextAlignment(.leading)
                                    .fixedSize()
                            }
                            .padding()
                            .background{
                                LinearGradient(gradient: Gradient(colors: [.yellow, .orange]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                            }
                            .cornerRadius(15)
                            .overlay{
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 5)
                                    .padding(1)
                            }
                            .padding(.bottom)
                        }
                        .buttonStyle(.roundedAndShadow6)
                        
                        Button {
                        } label: {
                            HStack {
                                Text("🍬 🍭 🧁 🍩 🍡")
                                    .bold()
                                    .font(.system(size: deviceWidth / 15))
                                    .customTextStroke(width: 1.8)
                                    .multilineTextAlignment(.leading)
                                    .fixedSize()
                                Spacer()
                                Text("💎 50")
                                    .bold()
                                    .font(.system(size: deviceWidth / 21))
                                    .customTextStroke(width: 1.5)
                                    .multilineTextAlignment(.leading)
                                    .fixedSize()
                            }
                            .padding()
                            .background{
                                LinearGradient(gradient: Gradient(colors: [.yellow, .orange]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                            }
                            .cornerRadius(15)
                            .overlay{
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 5)
                                    .padding(1)
                            }
                            .padding(.bottom)
                        }
                        .buttonStyle(.roundedAndShadow6)
                        
                        Button {
                        } label: {
                            HStack {
                                Text("🎃 👻 🧛‍♂️ 💀 🩸")
                                    .bold()
                                    .font(.system(size: deviceWidth / 15))
                                    .customTextStroke(width: 1.8)
                                    .multilineTextAlignment(.leading)
                                    .fixedSize()
                                Spacer()
                                Text("💎 100")
                                    .bold()
                                    .font(.system(size: deviceWidth / 21))
                                    .customTextStroke(width: 1.5)
                                    .multilineTextAlignment(.leading)
                                    .fixedSize()
                            }
                            .padding()
                            .background{
                                LinearGradient(gradient: Gradient(colors: [.yellow, .orange]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                            }
                            .cornerRadius(15)
                            .overlay{
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 5)
                                    .padding(1)
                            }
                            .padding(.bottom)
                        }
                        .buttonStyle(.roundedAndShadow6)
                        
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
                                            appModel.showSkinsMenu = false
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
    SkinsMenuView()
}

struct ShapesView: View {
    let shapeType: ShapeType
    
    var body: some View {
        switch shapeType {
        case .circle:
            ZStack {
                Text("🔵")
                    .font(.system(size: idiom == .pad ? 90 : 53))
                    .customTextStroke()
                    .scaleEffect(1.5)
            }
            .frame(width: deviceWidth / 6, height: deviceWidth / 6)
        case .square:
            ZStack {
                Text("🟩")
                    .font(.system(size: idiom == .pad ? 90 : 53))
                    .customTextStroke()
                    .scaleEffect(1.5)
            }
            .frame(width: deviceWidth / 6, height: deviceWidth / 6)
        case .triangle:
            ZStack {
                Text("🔻")
                    .font(.system(size: idiom == .pad ? 90 : 53))
                    .customTextStroke(width: 1)
                    .scaleEffect(2.4)
            }
            .frame(width: deviceWidth / 6, height: deviceWidth / 6)
            
        case .star:
            ZStack {
                Text("⭐️")
                    .font(.system(size: idiom == .pad ? 90 : 53))
                    .customTextStroke()
                    .scaleEffect(1.7)
            }
            .frame(width: deviceWidth / 6, height: deviceWidth / 6)

        case .heart:
            ZStack {
                Text("💜")
                    .font(.system(size: idiom == .pad ? 90 : 53))
                    .customTextStroke()
                    .scaleEffect(1.6)
                
            }
            .frame(width: deviceWidth / 6, height: deviceWidth / 6)
        }
    }
}



enum ShapeType: Int, Identifiable, Equatable, CaseIterable {
    case circle, square, triangle, star, heart
    
    var id: Int { rawValue }
}

enum AnimalType: Int, Identifiable, Equatable, CaseIterable {
    case dog, cat, fox, monkey, lion
    
    var id: Int { rawValue }
}

enum FruitType: Int, Identifiable, Equatable, CaseIterable {
    case apple, banana, orange, watermelon, mango
    
    var id: Int { rawValue }
}

enum SweetType: Int, Identifiable, Equatable, CaseIterable {
    case candy, lolipop, cupcake, donut, stick
    
    var id: Int { rawValue }
}

enum HalloweenType: Int, Identifiable, Equatable, CaseIterable {
    case pumpkin, ghost, vampire, skull, blood
    
    var id: Int { rawValue }
}
