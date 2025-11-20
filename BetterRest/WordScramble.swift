import SwiftUI


struct WordScramble: View {
    @State private var newWord = ""
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showError = false
    @State private var isOn = false
    
    @State private var score: Int = 0
    
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
                
                Toggle("Animate", isOn: $isOn.animation())
            }
            .navigationTitle(rootWord)
            .navigationSubtitle("Your Score: \(score)")
            .onSubmit (addNewWord)
            .onAppear (perform: startGame)
            .alert(errorTitle, isPresented: $showError) {} message: {
                Text(errorMessage)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) { Button("Resart") { startGame() } }
            }
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        guard isRootWord(word: answer) else {
            wordError(title: "Root word", message: "The word is already given, try to make new word form it")
            return
        }
        
        guard isShort(word: answer) else {
            wordError(title: "Short", message: "The word is too short")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Alreadey added", message: "This word is already added")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Not possible", message: "This word can't be made with \(rootWord)")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "No such word", message: "There are no such word in English language as \"\(answer)\"")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        playerScore(word: answer)
        newWord = ""
    }
    
    func playerScore(word: String) {
        if word.count == 3 {
            score += 1
        } else if word.count == 4 {
            score += 2
        } else if word.count >= 7 {
            score = word.count + 2
        } else {
            score = word.count
        }
    }
    
    func isRootWord(word: String) -> Bool {
        !(word == rootWord)
    }
    
    func isShort(word: String) -> Bool {
        !(word.count < 3)
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var temWord = rootWord
        
        for letter in word {
            if let pos = temWord.firstIndex(of: letter) {
                temWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let checkRange = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: checkRange, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showError = true
    }
    
    func startGame() {
        if let startWordUrl = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordUrl, encoding: .utf8) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "Slikworm"
                usedWords = []
                score = 0
                newWord = ""
                return
            }
        }
        fatalError("Could not load start.txt from bundle")
    }

}

#Preview {
    WordScramble()
}
