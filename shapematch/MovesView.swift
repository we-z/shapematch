//
//  MovesView.swift
//  Shape Swap
//
//  Created by Wheezy Capowdis on 10/4/24.
//

import SwiftUI

struct MovesView: View {
    var body: some View {
        VStack{
            Text("🧑‍🏫 Moves 🧑‍🏫")
            Text("This is the least number of moves possible To match the pattern of shapes in the top grid.")
                .multilineTextAlignment(.leading)
            Spacer()
            Text("Tip 1: if a shape is already in the right place don’t move it.")
                .multilineTextAlignment(.leading)
            Text("Tip 2: remember, each swap moves 2 shapes, make sure your swaps are efficient and moving both shapes in the correct direction")
                .multilineTextAlignment(.leading)
            Text("Tip 3: Count the number of moves for each shape and start with the one that requires the most moves")
                .multilineTextAlignment(.leading)
        }
        .padding()
    }
}

#Preview {
    MovesView()
}
