//
//  MovesView.swift
//  Shape Swap
//
//  Created by Wheezy Capowdis on 10/4/24.
//

import SwiftUI

struct MovesView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.orange, .red]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
            VStack{
                Capsule()
                    .foregroundColor(.red)
                    .frame(width: 45, height: 9)
                    .customTextStroke()
                Text("🧑‍🏫 Moves 🧑‍🏫")
                    .bold()
                    .font(.system(size: deviceWidth / 9))
                    .customTextStroke(width: 3)
                Spacer()
                Text("Use the minimum\nnumber of moves\nto match the\nshape pattern 🧠")
                    .bold()
                    .font(.system(size: deviceWidth / 12))
                    .customTextStroke()
                    .multilineTextAlignment(.center)
                    .fixedSize()
                Spacer()
                HStack {
                    Text("Tip 1️⃣ : If a shape is in the right\nplace, don’t move it.")
                        .bold()
                        .font(.system(size: deviceWidth / 21))
                        .customTextStroke(width: 1.5)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                HStack {
                Text("Tip 2️⃣ : Remember, each swap\nmoves 2 shapes, make sure\nyour swaps are efficient and are\nmoving both shapes in the correct direction")
                    .bold()
                    .font(.system(size: deviceWidth / 21))
                    .customTextStroke(width: 1.5)
                    .multilineTextAlignment(.leading)
                    Spacer()
                }
                .padding(.vertical)
                HStack {
                    Text("Tip 3️⃣ : Count the number of\nmoves for each shape and start\nwith the one that requires the\nmost moves")
                        .bold()
                        .font(.system(size: deviceWidth / 21))
                        .customTextStroke(width: 1.5)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
            }
            .padding(30)
        }
        .cornerRadius(30)
        .overlay{
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.black, lineWidth: 9)
                .padding(1)
        }
        .padding()
        
    }
    
}

#Preview {
    MovesView()
}
