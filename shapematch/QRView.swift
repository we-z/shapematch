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
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
            VStack {
                ZStack{
                    RotatingSunView()
                        .scaleEffect(1.8)
                        .frame(width: 1, height: 1)
                    
                    Image("qrcode")
                        .resizable()
                        .frame(width: 300, height: 300)
                        .cornerRadius(30)
                        .overlay {
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.yellow, lineWidth: idiom == .pad ? 11 : 9)
                                .padding(1)
                                .shadow(color: .blue, radius: 6)
                        }
                        .shadow(color: .blue, radius: 6)
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
