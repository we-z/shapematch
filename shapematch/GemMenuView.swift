//
//  GemMenuView.swift
//  Shape Shuffle
//
//  Created by Wheezy Capowdis on 8/22/24.
//

import SwiftUI
import StoreKit

struct GemMenuView: View {
    @State var isProcessingPurchase = false
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @StateObject var storeKit = StoreKitManager()
    @ObservedObject var userPersistedData = UserPersistedData.sharedUserPersistedData
    @State var cardOffset: CGFloat = deviceWidth * 2
    @State private var sheetPresented : Bool = false
    
    @State var GemPacks: [GemPack] = [
        GemPack(amount: 10, cost: "1.99", packID: "GemPack10"),
        GemPack(amount: 100, cost: "14.99", packID: "GemPack100"),
        GemPack(amount: 1000, cost: "99.99", packID: "GemPack1000")
    ]
    
    @MainActor
    func buyGems(pack: GemPack) async {
        do {
            if (try await storeKit.purchase(packID: pack.packID)) != nil{
                DispatchQueue.main.async {
                    appModel.amountBought = pack.amount
                    appModel.boughtGems.toggle()
                    appModel.showGemMenu = false
                    userPersistedData.incrementBalance(amount: pack.amount)
                }
            }
        } catch {
            print("Purchase failed: \(error)")
        }
        isProcessingPurchase = false
    }
    
    @MainActor
    private func render() -> UIImage? {
        return UIImage(named: "linkcard")  // Make sure "linkcard" exists in assets
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    DispatchQueue.main.async { [self] in
                        withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                            cardOffset = deviceWidth * 2
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                                if userPersistedData.hapticsOn {
                                    impactLight.impactOccurred()
                                }
                                appModel.showGemMenu = false
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
                                            appModel.showGemMenu = false
                                        }
                                    }
                                }
                            }
                        }
                )
            VStack {
                Spacer()
                VStack {
                    VStack(spacing: 21) {
                        Text("Gem Shop")
                            .bold()
                            .font(.system(size: deviceWidth/9))
                            .customTextStroke(width: 2.7)
                        ForEach(0..<GemPacks.count, id: \.self) { index in
                            Button {
                                isProcessingPurchase = true
                                Task {
                                    await buyGems(pack: GemPacks[index])
                                }
                            } label: {
                                HStack{
                                    Text("💎 \(GemPacks[index].amount)")
                                        .bold()
                                        .font(.system(size: deviceWidth/15))
                                        .fixedSize()
                                        .scaleEffect(1.2)
                                        .customTextStroke(width: 2.4)
                                        .padding(12)
                                        .padding(.horizontal, idiom == .pad ? 30 : 0)
                                    Spacer()
                                    Text("$\(GemPacks[index].cost)")
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
                                        .fixedSize()
                                }
                                .padding()
                                .background{
                                    LinearGradient(gradient: Gradient(colors: [.teal, .blue]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                                }
                                .cornerRadius(21)
                                .overlay{
                                    RoundedRectangle(cornerRadius: 21)
                                        .stroke(Color.black, lineWidth: 6)
                                        .padding(1)
//                                        .shadow(color: .black, radius: 3)
                                }
//                                .shadow(color: .blue, radius: 3)
                                .padding(.horizontal, 27)
                                .padding(.vertical, 3)
                            }
                            .buttonStyle(.roundedAndShadow6)
                            .shadow(color: .blue, radius: 6)
                        }

                            Button {
                                if userPersistedData.hapticsOn {
                                    impactLight.impactOccurred()
                                }
                                self.sheetPresented = true
                            } label: {
                                Text("Share! 📲")
                                    .italic()
                                    .bold()
                                    .font(.system(size: deviceWidth/18))
                                    .customTextStroke(width:1.5)
                                    .shadow(color: .blue, radius: 6)
                            }
                    }
                    .padding(.vertical, 27)
                    
                }
                .background{
                    ZStack {
                        LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                        RotatingSunView()
                            .frame(width: 1, height: 1)
                            .offset(y: -(deviceWidth/1.4))
                    }
                }
                .cornerRadius(39)
                .overlay{
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.blue, lineWidth: 6)
                        .shadow(color: .black, radius: 3)
                }
                .shadow(color: .black, radius: 3)
                .padding()
                .offset(y: cardOffset)
                
            }
            .padding(.bottom, idiom == .pad ? 90 : 0)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        cardOffset = gesture.translation.height
                    }
                    .onEnded { gesture in
                        if gesture.translation.height > 0 {
                            DispatchQueue.main.async { [self] in
                                withAnimation(.interpolatingSpring(mass: 3.0, stiffness: 100.0, damping: 18.0, initialVelocity: 0.0)) {
                                    cardOffset = deviceWidth * 2
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                                        if userPersistedData.hapticsOn {
                                            impactLight.impactOccurred()
                                        }
                                        appModel.showGemMenu = false
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
        .sheet(isPresented: $sheetPresented, content: {
                
            if let url = URL(string: "https://apps.apple.com/us/app/shape-swap-puzzle/id6670235177") {
                ShareView(url: url)
                    .ignoresSafeArea()
            }
            
        })
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
            Text("Hang tight! your gems\nare on there way! 💎")
                .bold()
                .multilineTextAlignment(.center)
                .font(.system(size: deviceWidth/13))
                .customTextStroke()
            Spacer()
        }
        .frame(height: deviceWidth/3)
        .background{
            LinearGradient(gradient: Gradient(colors: [.teal, .blue]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
        }
        .cornerRadius(30)
        .overlay{
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.black, lineWidth: 6)
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
