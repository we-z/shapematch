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
            Color.blue
            VStack {
                ZStack{
                    Rectangle()
                        .foregroundColor(.black)
                        .frame(width: 315, height: 315)
                        .cornerRadius(54)
                    Image("qrcode")
                        .resizable()
                        .frame(width: 300, height: 300)
                        .cornerRadius(45)
                }
                Text("Shape Swap")
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