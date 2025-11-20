//
//  Practice.swift
//  BetterRest
//
//  Created by Hafizur Rahman on 20/11/25.
//

import SwiftUI

struct Practice: View {
    var body: some View {
        ForEach(1..<5) {
            Text("Hello World \($0)")
        }
    }
}

#Preview {
    Practice()
}
