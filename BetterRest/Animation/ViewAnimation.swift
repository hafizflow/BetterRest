//
//  ViewAnimation.swift
//  BetterRest
//
//  Created by Hafizur Rahman on 19/11/25.
//

import SwiftUI

struct ViewAnimation: View {
    @State private var isOn = false
    
    var body: some View {
        VStack {
            Button("Tap me") {
                withAnimation {
                    isOn.toggle()
                }
            }
            
            if isOn {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
            }
        }
    }
}


struct CardAnimation: View {
    @State private var position = CGSize.zero
    
    var body: some View  {
        LinearGradient(colors: [.yellow, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
            .frame(width: 300, height: 200)
            .clipShape(.rect(cornerRadius: 20))
            .offset(position)
            .gesture (
                DragGesture()
                    .onChanged { position = $0.translation }
                    .onEnded { _ in
                        withAnimation(.bouncy) {
                            position = .zero
                        }
                    }
            )
    }
}

#Preview {
    CardAnimation()
}
