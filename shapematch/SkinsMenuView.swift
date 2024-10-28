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
    @Environment(\.dismiss) private var dismiss
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
                            ForEach(0..<appModel.skins.count, id: \.self) { index in
                                let skinPack = appModel.skins[index]
                                Button {
                                    if userPersistedData.purchasedSkins.contains(skinPack.SkinID) {
                                        userPersistedData.chosenSkin = skinPack.SkinID
                                    } else {
                                        if skinPack.cost <= userPersistedData.gemBalance {
                                            userPersistedData.decrementBalance(amount: skinPack.cost)
                                            userPersistedData.purchasedSkins += skinPack.SkinID
                                            userPersistedData.purchasedSkins += ","
                                            userPersistedData.chosenSkin = skinPack.SkinID
                                        } else {
                                            dismiss()
                                            appModel.showGemMenu = true
                                        }
                                    }
                                } label: {
                                    HStack {
                                        
                                        ForEach(ShapeType.allCases) { shape in
                                            ShapesView(shapeType: shape, skinType: skinPack.SkinID)
                                                .frame(width: deviceWidth / 10, height: deviceWidth / 10)
                                                .scaleEffect(0.4)
                                                .fixedSize()
                                        }
                                        
                                        Spacer()
                                        if userPersistedData.purchasedSkins.contains(skinPack.SkinID) {
                                            Text(skinPack.SkinID == userPersistedData.chosenSkin ? "✅" : "⭕️")
                                                .bold()
                                                .font(.system(size: deviceWidth / 15))
                                                .customTextStroke(width: 1.8)
                                                .multilineTextAlignment(.leading)
                                                .fixedSize()
                                        } else {
                                            Text("💎 \(skinPack.cost)")
                                                .bold()
                                                .font(.system(size: deviceWidth / 15))
                                                .customTextStroke(width: 1.8)
                                                .multilineTextAlignment(.leading)
                                                .fixedSize()
                                        }
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
                                    .padding(.horizontal)
                                    .padding(.vertical, 9)
                                }
                                .buttonStyle(.roundedAndShadow6)
                            }
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
    let skinType: String
    var body: some View {
        switch shapeType {
            case .circle:
                ZStack {
                    switch skinType {
                    case "fruits":
                        Text("🍎")
                            .customTextStroke()
                            .scaleEffect(1.5)
                    case "animals":
                        Text("🐶")
                            .customTextStroke()
                            .scaleEffect(1.5)
                    case "sweets":
                        Text("🍬")
                            .customTextStroke()
                            .scaleEffect(1.5)
                    case "halloween":
                        Text("🎃")
                            .customTextStroke()
                            .scaleEffect(1.5)
                    default:
                        Text("🔵")
                            .customTextStroke()
                            .scaleEffect(1.5)
                    }
                }
                .frame(width: deviceWidth / 6, height: deviceWidth / 6)
                .font(.system(size: idiom == .pad ? 90 : 53))
            case .square:
                ZStack {
                    switch skinType {
                    case "fruits":
                        Text("🍌")
                            .customTextStroke()
                            .scaleEffect(1.5)
                    case "animals":
                        Text("🐱")
                            .customTextStroke()
                            .scaleEffect(1.5)
                    case "sweets":
                        Text("🍭")
                            .customTextStroke()
                            .scaleEffect(1.5)
                    case "halloween":
                        Text("👻")
                            .customTextStroke()
                            .scaleEffect(1.5)
                    default:
                        Text("🟩")
                            .customTextStroke()
                            .scaleEffect(1.5)
                    }
                }
                .frame(width: deviceWidth / 6, height: deviceWidth / 6)
                .font(.system(size: idiom == .pad ? 90 : 53))
            case .triangle:
                ZStack {
                    switch skinType {
                    case "fruits":
                        Text("🍊")
                            .customTextStroke()
                            .scaleEffect(1.5)
                    case "animals":
                        Text("🦊")
                            .customTextStroke()
                            .scaleEffect(1.5)
                    case "sweets":
                        Text("🧁")
                            .customTextStroke()
                            .scaleEffect(1.5)
                    case "halloween":
                        Text("🧛‍♂️")
                            .customTextStroke()
                            .scaleEffect(1.5)
                    default:
                        Text("🔻")
                            .customTextStroke(width: 1)
                            .scaleEffect(2.4)
                    }
                }
                .frame(width: deviceWidth / 6, height: deviceWidth / 6)
                .font(.system(size: idiom == .pad ? 90 : 53))
                
            case .star:
                ZStack {
                    switch skinType {
                    case "fruits":
                        Text("🍉")
                            .customTextStroke()
                            .scaleEffect(1.5)
                    case "animals":
                        Text("🐵")
                            .customTextStroke()
                            .scaleEffect(1.5)
                    case "sweets":
                        Text("🍩")
                            .customTextStroke()
                            .scaleEffect(1.5)
                    case "halloween":
                        Text("💀")
                            .customTextStroke()
                            .scaleEffect(1.5)
                    default:
                        Text("⭐️")
                            .customTextStroke()
                            .scaleEffect(1.7)
                    }
                }
                .frame(width: deviceWidth / 6, height: deviceWidth / 6)
                .font(.system(size: idiom == .pad ? 90 : 53))

            case .heart:
                ZStack {
                    switch skinType {
                    case "fruits":
                        Text("🥭")
                            .customTextStroke()
                            .scaleEffect(1.5)
                    case "animals":
                        Text("🦁")
                            .customTextStroke()
                            .scaleEffect(1.5)
                    case "sweets":
                        Text("🍡")
                            .customTextStroke()
                            .scaleEffect(1.5)
                    case "halloween":
                        Text("🩸")
                            .customTextStroke()
                            .scaleEffect(1.5)
                    default:
                        Text("💜")
                            .customTextStroke()
                            .scaleEffect(1.6)
                    }
                    
                }
                .frame(width: deviceWidth / 6, height: deviceWidth / 6)
                .font(.system(size: idiom == .pad ? 90 : 53))
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
