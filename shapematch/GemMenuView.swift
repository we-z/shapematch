//
//  GemMenuView.swift
//  Shape Shuffle
//
//  Created by Wheezy Capowdis on 8/22/24.
//

import SwiftUI

struct GemMenuView: View {
    @State var isProcessingPurchase = false
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @StateObject var storeKit = StoreKitManager()
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    @State var cardOffset: CGFloat = deviceWidth * 2
    
    @State var GemPack10: GemPack = GemPack(amount: 10, cost: "1.99", packID: "GemPack10")
    @State var GemPack100: GemPack = GemPack(amount: 100, cost: "14.99", packID: "GemPack100")
    @State var GemPack1000: GemPack = GemPack(amount: 1000, cost: "99.99", packID: "GemPack1000")
    
    @MainActor
    func buyGems(pack: GemPack) async {
        do {
            if (try await storeKit.purchase(packID: pack.packID)) != nil{
                DispatchQueue.main.async {
                    userPersistedData.incrementBalance(amount: pack.amount)
                }
            }
        } catch {
            print("Purchase failed: \(error)")
        }
        isProcessingPurchase = false
    }
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    appModel.showGemMenu = false
                }
            VStack {
                Spacer()
                VStack {
                    HStack{
                        Spacer()
                        Button {
                            impactHeavy.impactOccurred()
                            appModel.showGemMenu = false
                        } label: {
                            Text("❌")
                                .font(.system(size: deviceWidth/15))
                                .customTextStroke()
                                .padding([.trailing, .top], 21)
                        }
                    }
                    Text("💎 Gems 💎")
                        .bold()
                        .font(.system(size: deviceWidth/9))
                        .customTextStroke()
                    
                    //            Spacer()
                    VStack(spacing: 21) {
                        Button {
                            isProcessingPurchase = true
                            Task {
                                await buyGems(pack: GemPack10)
                            }
                        } label: {
                            HStack{
                                Text("🐟")
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
                                    .customTextStroke(width: 1.8)
                                Spacer()
                                Text("$1.99")
                                    .bold()
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
                                    .stroke(Color.black, lineWidth: 6)
                                    .padding(1)
                            }
                            .padding(.horizontal, 30)
                        }
                        .buttonStyle(.roundedAndShadow6)
                        Button {
                            isProcessingPurchase = true
                            Task {
                                await buyGems(pack: GemPack100)
                            }
                        } label: {
                            HStack{
                                Text("🐬")
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
                                    .customTextStroke(width: 1.8)
                                
                                Spacer()
                                Text("$14.99")
                                    .bold()
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
                                    .stroke(Color.black, lineWidth: 6)
                                    .padding(1)
                            }
                            .padding(.horizontal, 30)
                        }
                        .buttonStyle(.roundedAndShadow6)
                        Button {
                            isProcessingPurchase = true
                            Task {
                                await buyGems(pack: GemPack1000)
                            }
                        } label: {
                            HStack{
                                Text("🐳")
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
                                    .customTextStroke(width: 1.8)
                                
                                Spacer()
                                Text("$99.99")
                                    .bold()
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
                                    .stroke(Color.black, lineWidth: 6)
                                    .padding(1)
                            }
                            .padding(.horizontal, 30)
                        }
                        .buttonStyle(.roundedAndShadow6)
                    }
                    .padding(.bottom, 30)
                }
                .background(.cyan)
                .cornerRadius(30)
                .overlay{
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.black, lineWidth: 9)
                        .padding(1)
                }
                .padding()
                .offset(y: cardOffset)
                
            }
            if isProcessingPurchase {
                ProgressView()
                .scaleEffect(3)
                .font(.system(size: deviceWidth))
                VStack {
                    HangTight()
                    Spacer()
                }
            }
        }
        .allowsHitTesting(!isProcessingPurchase)
        .onAppear {
            DispatchQueue.main.async {
                withAnimation(.interpolatingSpring(mass: 2.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                    cardOffset = 0
                }
            }
        }
    }
}

#Preview {
    GemMenuView()
}

struct GemPack: Hashable {
    let amount: Int
    let cost: String
    let packID: String

    func hash(into hasher: inout Hasher) {
        // Implement a custom hash function that combines the hash values of properties that uniquely identify a character
        hasher.combine(packID)
    }

    static func ==(lhs: GemPack, rhs: GemPack) -> Bool {
        // Implement the equality operator to compare characters based on their unique identifier
        return lhs.packID == rhs.packID
    }
}

struct HangTight: View {
    @State var dissapear = false
    @State var cardOffset: CGFloat = -(deviceWidth / 2)
    var body: some View {
        HStack{
            Spacer()
            Text("Hang tight!\nWe’re grabbing\nyour Gems 💎")
                .bold()
                .multilineTextAlignment(.center)
                .font(.system(size: deviceWidth/9))
                .customTextStroke()
            Spacer()
        }
        .frame(height: deviceWidth/1.8)
        .background(Color.green)
        .cornerRadius(30)
        .overlay{
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.black, lineWidth: 9)
                .padding(1)
        }
        .padding()
        .offset(y: cardOffset)
        .onAppear{
            DispatchQueue.main.async {
                withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                    cardOffset = 0
                }
            }
        }
        .allowsHitTesting(false)
    }
}
