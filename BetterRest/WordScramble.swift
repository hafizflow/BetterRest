import SwiftUI


struct WordScramble: View {
    @State private var newWord = ""
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit (addNewWord)
            .onAppear (perform: startGame)
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
    }
    
    func startGame() {
        if let startWordUrl = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordUrl, encoding: .ascii) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "Slikworm"
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle")
    }

}

#Preview {
    WordScramble()
}
