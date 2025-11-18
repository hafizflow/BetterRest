    //
    //  BoxAnimation.swift
    //  BetterRest
    //
    //  Created by Hafizur Rahman on 18/11/25.
    //

import SwiftUI

struct BoxAnimation: View {
    @State private var animationState = false
    
    var body: some View {
        Button("Tap me") {
            animationState.toggle()
        }
        .frame(width: 200, height: 200)
        .background(animationState ? Color.red : Color.blue)
        .foregroundStyle(.white)
        .animation(.default, value: animationState)
        .clipShape(.rect(cornerRadius: animationState ? 40 : 0))
        .animation(.default, value: animationState)
    }
}

#Preview {
    BoxAnimation()
}
