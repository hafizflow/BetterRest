//
//  Animation.swift
//  BetterRest
//
//  Created by Hafizur Rahman on 17/11/25.
//

import SwiftUI

struct Animation: View {
    @State private var animationAmount = 1.0
    @State private var animationDegree = 0.0
    
    var body: some View {
        NavigationStack {
            VStack {
                Button("Tap Me") {
                    withAnimation(.spring(duration: 1, bounce: 0.5)) {
                        animationDegree += 360
                    }
                }
                .padding(50)
                .background(.red)
                .foregroundStyle(.white)
                .clipShape(.circle)
                .overlay {
                    Circle()
                        .stroke(.red)
                        .scaleEffect(animationAmount)
                        .opacity(2 - animationAmount)
                        .animation(
                            .easeOut(duration: 1)
                            .repeatForever(autoreverses: false),
                            value: animationAmount
                        )
                }
                .rotation3DEffect(.degrees(animationDegree), axis: (0, 1, 0))
            }
            .navigationTitle("Practice")
        }
        .onAppear {
            animationAmount = 2
        }
    }
}

#Preview {
    Animation()
}
