import SwiftUI

@Observable
class Info {
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

struct Practice: View {
    @State private var user = Info(name: "hafiz", age: 23)
    
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                Home(user: user)
            }
            
            Tab("House", systemImage: "house") {
                House(user: user)
            }
        }
    }
}

struct Home: View {
    @Bindable var user: Info     // Editable
    
    var body: some View {
        VStack {
            Text("Home Screen")
            Text("Name: \(user.name)")
            
            TextField("Enter Name...", text: $user.name)   // Editable
                .textFieldStyle(.roundedBorder)
        }
        .padding()
    }
}

struct House: View {
    var user: Info    // ❗ Not Bindable → Read-Only
    
    var body: some View {
        VStack {
            Text("House Screen (Read Only)")
            Text("Name: \(user.name)")   // Shows updated value
        }
        .padding()
    }
}


#Preview {
    Practice()
}
