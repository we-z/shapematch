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
        VStack{
            SkinsButtonsView()
            HStack {
                Text("Customize!")
//                    .italic()
                    .bold()
                    .font(.system(size: deviceWidth / 9))
                    .customTextStroke(width: 2.1)
                    
            }
            VStack {
                ScrollView {
                    ForEach(0..<appModel.skins.count, id: \.self) { index in
                        let skinPack = appModel.skins[index]
                        Button {
                            if userPersistedData.hapticsOn {
                                impactLight.impactOccurred()
                            }
                            if userPersistedData.purchasedSkins.contains(skinPack.SkinID) {
                                print("Purcahsed")
                                userPersistedData.chosenSkin = skinPack.SkinID
                            } else {
                                if skinPack.cost <= userPersistedData.gemBalance {
                                    userPersistedData.decrementBalance(amount: skinPack.cost)
                                    userPersistedData.purchasedSkins += skinPack.SkinID
                                    userPersistedData.purchasedSkins += ","
                                    userPersistedData.setSkin(skinID: skinPack.SkinID)
                                } else {
                                    appModel.showGemMenu = true
                                }
                            }
                        } label: {
                            HStack {
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
                                Spacer()
                                
                                HStack {
                                    ForEach(ShapeType.allCases) { shape in
                                        ShapesView(shapeType: shape, skinType: skinPack.SkinID)
                                            .frame(width: deviceWidth / 10, height: deviceWidth / 10)
                                            .scaleEffect(0.4)
                                            .fixedSize()
                                    }
                                }
                                .padding()
                                .background{
                                    ZStack{
                                        Color.white
                                        Color.blue.opacity(0.6)
                                    }
                                }
                                .cornerRadius(idiom == .pad ? 42 :21)
                                .overlay{
                                    RoundedRectangle(cornerRadius: idiom == .pad ? 42 : 21)
                                        .stroke(Color.yellow, lineWidth: idiom == .pad ? 9 : 5)
                                        .padding(1)
                                        .shadow(radius: 3)
                                }
                                .shadow(radius: 3)
                                .padding(.trailing, idiom == .pad ? 30 : 15)
                                .padding(.vertical, idiom == .pad ? 15 : 9)
                            }
                        }
                    }
                }
            }
        }
        .background{
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                    .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    SkinsMenuView()
}

struct ShapesView: View {
    let shapeType: ShapeType
    let skinType: String

    var body: some View {
        if let skin = AppModel.sharedAppModel.skins.first(where: { $0.SkinID == skinType }),
           let symbol = skin.symbols[shapeType],
           let scaleEffect = skin.scaleEffects[shapeType],
           let strokeWidth = skin.strokeWidths[shapeType] {
            Text(symbol)
                .customTextStroke(width: strokeWidth)
                .scaleEffect(scaleEffect)
                .frame(width: deviceWidth / 6, height: deviceWidth / 6)
                .font(.system(size: idiom == .pad ? 90 : 53))
        } else {
            Text("?") // Fallback for unknown skin or shape
                .customTextStroke()
                .scaleEffect(1.5)
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
    let symbols: [ShapeType: String] // Symbols for each ShapeType
    let scaleEffects: [ShapeType: CGFloat] // Scale effect for each ShapeType
    let strokeWidths: [ShapeType: CGFloat] // Stroke width for each ShapeType

    func hash(into hasher: inout Hasher) {
        hasher.combine(SkinID)
    }

    static func == (lhs: Skin, rhs: Skin) -> Bool {
        return lhs.SkinID == rhs.SkinID
    }
}
