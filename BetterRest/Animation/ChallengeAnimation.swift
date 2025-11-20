//
//  ChallengeAnimation.swift
//  BetterRest
//
//  Created by Hafizur Rahman on 19/11/25.
//

import SwiftUI

struct CornerAnimation: ViewModifier {
    let amount: Double
    let corner: UnitPoint
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: corner)
            .clipped()
    }
}

extension AnyTransition {
    static var animationPivot: AnyTransition {
        .modifier(
            active: CornerAnimation(amount: -90, corner: .topLeading),
            identity: CornerAnimation(amount: 0, corner: .topLeading)
        )
    }
}


struct ChallengeAnimation: View {
    @State private var animationAmount = 0.0
    @State private var fadeColor = true
    @State private var animationCard = false
    
    var body: some View {
        VStack (spacing: 20){
            Circle()
                .fill(.red)
                .frame(width: 200)
                .clipShape(.rect(cornerRadius: 28))
                .rotation3DEffect(.degrees(animationAmount), axis: (x: 0.0, y: 1.0, z: 0.0))
                .onTapGesture {
                    withAnimation(.spring(duration: 1, bounce: 0.5)) {
                        animationAmount += 360.0
                    }
                }
        
            Button {
                withAnimation(.spring(duration: 5)) {
                    fadeColor.toggle()
                }
            } label: {
                Text("Fade")
                    .padding(40)
                    .background(.red.opacity(fadeColor ? 1 : 0.25))
                    .foregroundStyle(.white)
                    .clipShape(.rect(cornerRadius: 20))
                    .scaleEffect(fadeColor ? 1 : 1.2)
            }
            
            
            ZStack {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .clipShape(.rect(cornerRadius: 28))
                
                if animationCard {
                    Rectangle()
                        .fill(.blue)
                        .frame(width: 200, height: 200)
                        .clipShape(.rect(cornerRadius: 28))
                        .transition(.animationPivot)
                        .zIndex(1)
                }
                    
            }
            .onTapGesture {
                withAnimation {
                    animationCard.toggle()
                }
            }
        }
    }
}


#Preview {
    ChallengeAnimation()
}
