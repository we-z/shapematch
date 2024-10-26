//
//  SkinsMenuView.swift
//  Shape Swap
//
//  Created by Wheezy Capowdis on 10/25/24.
//

import SwiftUI

struct SkinsMenuView: View {
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    var body: some View {
        VStack {
            VStack {
                VStack{
                    Capsule()
                        .foregroundColor(.red)
                        .frame(width: 45, height: 9)
                        .customTextStroke()
                    HStack {
                        Text("🍎  Skins  🐶")
                            .bold()
                            .font(.system(size: deviceWidth / 12))
                            .customTextStroke()
                            .padding(.vertical)
                    }
                    VStack {
                        ScrollView {
                            Button {
                            } label: {
                                HStack {
                                    
                                    ForEach(ShapeType.allCases) { shape in
                                        ShapesView(shapeType: shape)
                                            .frame(width: deviceWidth / 10, height: deviceWidth / 10)
                                            .scaleEffect(0.4)
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
                                .cornerRadius(21)
                                .overlay{
                                    RoundedRectangle(cornerRadius: 21)
                                        .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 5)
                                        .padding(1)
                                }
                                .padding()
                            }
                            .buttonStyle(.roundedAndShadow6)
                            
                            Button {
                            } label: {
                                HStack {
                                    Text("🍎 🍌 🍊 🍉 🥭")
                                        .bold()
                                        .font(.system(size: deviceWidth / 11))
                                        .customTextStroke(width: 1.8)
                                        .multilineTextAlignment(.leading)
                                        .fixedSize()
                                    Spacer()
                                    Text("💎 10")
                                        .bold()
                                        .font(.system(size: deviceWidth / 18))
                                        .customTextStroke(width: 1.5)
                                        .multilineTextAlignment(.leading)
                                        .fixedSize()
                                }
                                .padding()
                                .background{
                                    LinearGradient(gradient: Gradient(colors: [.yellow, .orange]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                                }
                                .cornerRadius(21)
                                .overlay{
                                    RoundedRectangle(cornerRadius: 21)
                                        .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 5)
                                        .padding(1)
                                }
                                .padding()
                            }
                            .buttonStyle(.roundedAndShadow6)
                            
                            Button {
                            } label: {
                                HStack {
                                    Text("🐶 😺 🦊 🐵 🦁")
                                        .bold()
                                        .font(.system(size: deviceWidth / 11))
                                        .customTextStroke(width: 1.8)
                                        .multilineTextAlignment(.leading)
                                        .fixedSize()
                                    Spacer()
                                    Text("💎 30")
                                        .bold()
                                        .font(.system(size: deviceWidth / 18))
                                        .customTextStroke(width: 1.5)
                                        .multilineTextAlignment(.leading)
                                        .fixedSize()
                                }
                                .padding()
                                .background{
                                    LinearGradient(gradient: Gradient(colors: [.yellow, .orange]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                                }
                                .cornerRadius(21)
                                .overlay{
                                    RoundedRectangle(cornerRadius: 21)
                                        .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 5)
                                        .padding(1)
                                }
                                .padding()
                            }
                            .buttonStyle(.roundedAndShadow6)
                            
                            Button {
                            } label: {
                                HStack {
                                    Text("🍬 🍭 🧁 🍩 🍡")
                                        .bold()
                                        .font(.system(size: deviceWidth / 11))
                                        .customTextStroke(width: 1.8)
                                        .multilineTextAlignment(.leading)
                                        .fixedSize()
                                    Spacer()
                                    Text("💎 50")
                                        .bold()
                                        .font(.system(size: deviceWidth / 18))
                                        .customTextStroke(width: 1.5)
                                        .multilineTextAlignment(.leading)
                                        .fixedSize()
                                }
                                .padding()
                                .background{
                                    LinearGradient(gradient: Gradient(colors: [.yellow, .orange]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                                }
                                .cornerRadius(21)
                                .overlay{
                                    RoundedRectangle(cornerRadius: 21)
                                        .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 5)
                                        .padding(1)
                                }
                                .padding()
                            }
                            .buttonStyle(.roundedAndShadow6)
                            
                            Button {
                            } label: {
                                HStack {
                                    Text("🎃 👻 🧛‍♂️ 💀 🩸")
                                        .bold()
                                        .font(.system(size: deviceWidth / 11))
                                        .customTextStroke(width: 1.8)
                                        .multilineTextAlignment(.leading)
                                        .fixedSize()
                                    Spacer()
                                    Text("💎 100")
                                        .bold()
                                        .font(.system(size: deviceWidth / 18))
                                        .customTextStroke(width: 1.5)
                                        .multilineTextAlignment(.leading)
                                        .fixedSize()
                                }
                                .padding()
                                .background{
                                    LinearGradient(gradient: Gradient(colors: [.yellow, .orange]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                                }
                                .cornerRadius(21)
                                .overlay{
                                    RoundedRectangle(cornerRadius: 21)
                                        .stroke(Color.black, lineWidth: idiom == .pad ? 9 : 5)
                                        .padding(1)
                                }
                                .padding()
                            }
                            .buttonStyle(.roundedAndShadow6)
                            
                        }
                    }
                }
                .padding(.top, 30)
            }
            
            .background{
                LinearGradient(gradient: Gradient(colors: [.orange, .red]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
            }
            
            
        }
        .ignoresSafeArea()
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

enum SkinType: Int, Identifiable, Equatable, CaseIterable {
    case shapes, fruits, animals, sweets, halloween
    
    var id: Int { rawValue }
}

struct Skin: Hashable {
    let SkinID: String
    let cost: Int
    
    func hash(into hasher: inout Hasher) {
        // Implement a custom hash function that combines the hash values of properties that uniquely identify a character
        hasher.combine(SkinID)
    }

    static func ==(lhs: Skin, rhs: Skin) -> Bool {
        // Implement the equality operator to compare characters based on their unique identifier
        return lhs.SkinID == rhs.SkinID
    }
}
