//
//  RandomGradientView.swift
//  Shape Swap
//
//  Created by Wheezy Capowdis on 8/27/24.
//

import SwiftUI

struct RandomGradientView: View {
    // Define a state for the gradient to trigger updates
    @State private var gradient: LinearGradient = LinearGradient(gradient: Gradient(colors: backgroundColors.randomElement(randomCount: 3).map { Color(hex: $0)! }), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1))
    
    // Timer to change the gradient periodically
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    var body: some View {
        Rectangle()
            .fill(gradient)
            .edgesIgnoringSafeArea(.all)
//            .onAppear{
//                // Animate the change
//                if #available(iOS 17, *) {
//                    withAnimation(.linear(duration: 3)) {
//                        self.gradient = self.randomGradient()
//                    }
//                }
//            }
//            .onReceive(timer) { _ in
//                // Generate a new gradient
//                // Animate the change
//                if #available(iOS 17, *) {
//                    withAnimation(.linear(duration: 3)) {
//                        self.gradient = self.randomGradient()
//                    }
//                }
//            }
    }
    
    func randomGradient() -> LinearGradient {
        let colors = backgroundColors.randomElement(randomCount: 3).map { Color(hex: $0)! }
        let startPoint = UnitPoint(x: 0, y: 0)
        let endPoint = UnitPoint(x: 1, y: 1)
        return LinearGradient(gradient: Gradient(colors: colors), startPoint: startPoint, endPoint: endPoint)
    }
}

#Preview {
    RandomGradientView()
}

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }
}

extension Array {
    func randomElement(randomCount: Int) -> [Element] {
        return (0..<2).compactMap { _ in self.randomElement() }
    }
}

extension UnitPoint {
    static var random: UnitPoint {
        return UnitPoint(x: CGFloat(Int.random(in: 0...1)), y: CGFloat(Int.random(in: 0...1)))
    }
}


let backgroundColors: [String] = [
    "#FF8A9E", // Vibrant Pink
    "#FFAB76", // Warm Peach
    "#FFD580", // Golden Apricot
    "#FFCC80", // Soft Amber
    "#80E5A5", // Fresh Mint Green
    "#80D4E5", // Bright Sky Blue
    "#B39DDB", // Rich Lavender
    "#E18FFF", // Vivid Lilac
    "#FFA3C1", // Bright Blush Pink
    "#9FA8DA", // Vibrant Periwinkle
    "#80D4FC", // Vivid Baby Blue
    "#DCE775", // Lively Lemon Green
    "#FF8A65", // Coral Peach
    "#A5D6A7"  // Fresh Mint
]
