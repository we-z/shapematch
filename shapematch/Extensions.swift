//
//  Extensions.swift
//  Shape Swap
//
//  Created by Wheezy Capowdis on 9/14/24.
//

import Foundation
import SwiftUI


extension Array where Element == [ShapeType] {
    mutating func swapAt(_ first: (row: Int, col: Int), _ second: (row: Int, col: Int)) {
        let temp = self[first.row][first.col]
        self[first.row][first.col] = self[second.row][second.col]
        self[second.row][second.col] = temp
    }
}

// Helper extension to chunk a flat array into subarrays of a given size (to reshape 1D array back to 2D

class HapticManager {
    static let instance = HapticManager()
    private init() {}
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
let impactLight = UIImpactFeedbackGenerator(style: .light)

enum SwipeDirection {
    case left, right, up, down
}

enum ShapeType: Int, Identifiable, Equatable, CaseIterable {
    case circle, square, triangle, star, heart
    
    var id: Int { rawValue }
}

struct StarShape: Shape {
    var points: Int
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius = min(rect.width, rect.height) / 2
        let angle = .pi / CGFloat(points)

        var path = Path()

        for i in 0..<2 * points {
            let isEven = i % 2 == 0
            let pointRadius = isEven ? radius : radius * 0.4
            let xPosition = center.x + pointRadius * sin(CGFloat(i) * angle)
            let yPosition = center.y - pointRadius * cos(CGFloat(i) * angle)

            let point = CGPoint(x: xPosition, y: yPosition)

            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }

        path.closeSubpath()

        return path
    }
}

struct HexagonShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius = min(rect.width, rect.height) / 2
        let angle = .pi / CGFloat(3)

        var path = Path()

        for i in 0..<6 {
            let pointRadius =  radius
            let xPosition = center.x + pointRadius * sin(CGFloat(i) * angle)
            let yPosition = center.y - pointRadius * cos(CGFloat(i) * angle)

            let point = CGPoint(x: xPosition, y: yPosition)

            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }

        path.closeSubpath()

        return path
    }
}

extension Shape {
    func style<S: ShapeStyle, F: ShapeStyle>(
        withStroke strokeContent: S,
        lineWidth: CGFloat = 1,
        fill fillContent: F
    ) -> some View {
        self.stroke(strokeContent, lineWidth: lineWidth)
    .background(fill(fillContent))
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}


struct RoundedHexagon: Shape {
    var cornerRadius: CGFloat
    
    var animatableData: CGFloat {
        get { return cornerRadius }
        set { cornerRadius = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let r = rect.width / 2
        let rc = cornerRadius
        let rn = r * 0.95 - rc
        
        // start angle at -18 degrees so that it points up
        var cangle = -30.0
        
        for i in 1 ... 6 {
            // compute center point of tip arc
            let cc = CGPoint(x: center.x + rn * CGFloat(cos(Angle(degrees: cangle).radians)), y: center.y + rn * CGFloat(sin(Angle(degrees: cangle).radians)))

            // compute tangent point along tip arc
            let p = CGPoint(x: cc.x + rc * CGFloat(cos(Angle(degrees: cangle - 30).radians)), y: cc.y + rc * CGFloat(sin(Angle(degrees: (cangle - 30)).radians)))

            if i == 1 {
                path.move(to: p)
            } else {
                path.addLine(to: p)
            }

            // add 144 degree arc to draw the corner
            path.addArc(center: cc, radius: rc, startAngle: Angle(degrees: cangle - 30), endAngle: Angle(degrees: cangle + 30), clockwise: false)

            // Move 144 degrees to the next point in the star
            cangle += 60
        }

        return path
    }
}

struct RoundedTriangle: Shape {
    var cornerRadius: CGFloat
    
    var animatableData: CGFloat {
        get { return cornerRadius }
        set { cornerRadius = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let r = rect.width / 2
        let rc = cornerRadius
        let rn = r * 0.95 - rc
        
        // start angle at -18 degrees so that it points up
        var cangle = 30.0
        
        for i in 1 ... 3 {
            // compute center point of tip arc
            let cc = CGPoint(x: center.x + rn * CGFloat(cos(Angle(degrees: cangle).radians)), y: center.y + rn * CGFloat(sin(Angle(degrees: cangle).radians)))

            // compute tangent point along tip arc
            let p = CGPoint(x: cc.x + rc * CGFloat(cos(Angle(degrees: cangle - 60).radians)), y: cc.y + rc * CGFloat(sin(Angle(degrees: (cangle - 60)).radians)))

            if i == 1 {
                path.move(to: p)
            } else {
                path.addLine(to: p)
            }

            // add 144 degree arc to draw the corner
            path.addArc(center: cc, radius: rc, startAngle: Angle(degrees: cangle - 60), endAngle: Angle(degrees: cangle + 60), clockwise: false)

            // Move 144 degrees to the next point in the star
            cangle += 120
        }

        return path
    }
}

struct RoundedStar: Shape {
    var cornerRadius: CGFloat
    
    var animatableData: CGFloat {
        get { return cornerRadius }
        set { cornerRadius = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let r = rect.width / 2
        let rc = cornerRadius
        let rn = r * 0.95 - rc
        
        // start angle at -18 degrees so that it points up
        var cangle = -18.0
        
        for i in 1 ... 5 {
            // compute center point of tip arc
            let cc = CGPoint(x: center.x + rn * CGFloat(cos(Angle(degrees: cangle).radians)), y: center.y + rn * CGFloat(sin(Angle(degrees: cangle).radians)))

            // compute tangent point along tip arc
            let p = CGPoint(x: cc.x + rc * CGFloat(cos(Angle(degrees: cangle - 72).radians)), y: cc.y + rc * CGFloat(sin(Angle(degrees: (cangle - 72)).radians)))

            if i == 1 {
                path.move(to: p)
            } else {
                path.addLine(to: p)
            }

            // add 144 degree arc to draw the corner
            path.addArc(center: cc, radius: rc, startAngle: Angle(degrees: cangle - 72), endAngle: Angle(degrees: cangle + 72), clockwise: false)

            // Move 144 degrees to the next point in the star
            cangle += 144
        }

        return path
    }
}


struct CustomTextStrokeModifier: ViewModifier {
    var id = UUID()
    var strokeSize: CGFloat = 1
    var strokeColor: Color = .black

    func body(content: Content) -> some View {
        if strokeSize > 0 {
            appliedStrokeBackground(content: content)
        } else {
            content
        }
    }

    func appliedStrokeBackground(content: Content) -> some View {
        
        content
            .background(
                Rectangle()
                    .foregroundColor(strokeColor)
                    .mask {
                        mask(content: content)
                    }
                    .padding(-30)
                    .allowsHitTesting(false)
            )
            .foregroundColor(.white)
    }

    func mask(content: Content) -> some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.01))
            if let resolvedView = context.resolveSymbol(id: id) {
                context.draw(resolvedView, at: .init(x: size.width/2, y: size.height/2))
            }
        } symbols: {
            content
                .tag(id)
                .blur(radius: idiom == .pad ? strokeSize * 2 : strokeSize)
        }
    }
}

extension View {
    func customTextStroke(color: Color = .black, width: CGFloat = 2.1) -> some View {
        self.modifier(CustomTextStrokeModifier(strokeSize: width, strokeColor: color))
    }
}

extension ButtonStyle where Self == RoundedAndShadowButtonStyle6 {
    static var roundedAndShadow6:RoundedAndShadowButtonStyle6 {
        RoundedAndShadowButtonStyle6()
    }
}

struct RoundedAndShadowButtonStyle6:ButtonStyle {
    @State var isPressed = false
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .compositingGroup()
            .shadow(color: .black, radius: 0.1, x: isPressed ? 0 : -6, y: isPressed ? 0 : 6)
            .offset(x: isPressed ? -6 : 0, y: isPressed ? 6 : 0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
            .onChange(of: configuration.isPressed) { currentlyPressing in
                if currentlyPressing {
                    impactHeavy.impactOccurred()
                }
                isPressed = true
                if !currentlyPressing {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [self] in
                        isPressed = false
                        impactHeavy.impactOccurred()
                    }
                }
            }
    }
}


extension View {
  @inlinable
  public func reverseMask<Mask: View>(
    alignment: Alignment = .center,
    @ViewBuilder _ mask: () -> Mask
  ) -> some View {
    self.mask {
      Rectangle()
        .overlay(alignment: alignment) {
          mask()
            .blendMode(.destinationOut)
        }
    }
  }
}


struct Position: Hashable {
    let row: Int
    let col: Int
}
