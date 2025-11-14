import SwiftUI

struct CustomMessageTextField: View {
    @State private var text: String = ""
    @FocusState private var isFocused: Bool
    @Namespace private var namespace
    @State private var selectedDepartment: String = "CSE"
    
    var body: some View {
        GlassEffectContainer(spacing: 12.0) {
            HStack(spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 22))
                        .foregroundColor(.gray)
                    
                    TextField("Message", text: $text)
                        .focused($isFocused)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                        .onSubmit { isFocused = false }
                    
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .glassEffect(.regular, in: .rect(cornerRadius: 28))
                .glassEffectID("textfield", in: namespace)
                .contentShape(Rectangle())
                .onTapGesture { isFocused = true }

                
                Picker(selection: $selectedDepartment) {
                    Text("CSE").tag("CSE")
                    Text("BBA").tag("BBA")
                } label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                        
                        Text(selectedDepartment)
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                    }
                }
                .pickerStyle(.menu)
                .frame(width: 90, height: 56)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 28))
                .glassEffectID("paperclip", in: namespace)
                .contentShape(Rectangle())
                .tint(.gray)
                
                
                if isFocused {
                    Button(action: {
                        isFocused = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                    }
                    .frame(width: 56, height: 56)
                    .glassEffect(.regular.interactive(), in: .circle)
                    .glassEffectID("close", in: namespace)
                    .glassEffectTransition(.matchedGeometry)
                    .contentShape(Rectangle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .animation(.smooth(duration: 0.5), value: isFocused)
    }
}

#Preview {
    CustomMessageTextField()
}
