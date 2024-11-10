//
//  QRView.swift
//  Shape Swap
//
//  Created by Wheezy Capowdis on 9/17/24.
//

import SwiftUI

struct QRView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.teal, .blue]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
            VStack {
                ZStack{
                    RotatingSunView()
                        .scaleEffect(1.8)
                        .frame(width: 1, height: 1)
                    Rectangle()
                        .foregroundColor(.black)
                        .frame(width: 315, height: 315)
                        .cornerRadius(54)
                    Image("qrcode")
                        .resizable()
                        .frame(width: 300, height: 300)
                        .cornerRadius(45)
                }
                Text("Shape Shuffle")
                    .font(.system(size: 45))
                    .bold()
                    .customTextStroke(width: 2.7)
            }
            .scaleEffect(0.75)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    QRView()
}
