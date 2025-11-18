import SwiftUI

struct AnimatedTimer: View {
    @State private var timeRemaining: Double = 60
    @State private var totalTime: Double = 60
    @State private var isRunning: Bool = false
    @State private var timer: Timer?
    
    var body: some View {
        VStack(spacing: 30) {
                // Animated Timer Display
            Text(timeString(from: timeRemaining))
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .foregroundColor(colorForTime())
                .contentTransition(.numericText())
            
                // Progress Circle
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 15)
                    .frame(width: 200, height: 200)
                
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining / totalTime))
                    .stroke(colorForTime(), style: StrokeStyle(lineWidth: 15, lineCap: .round))
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.1), value: timeRemaining)
            }
            
                // Control Buttons
            HStack(spacing: 20) {
                Button(action: resetTimer) {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                }
                
                Button(action: toggleTimer) {
                    Image(systemName: isRunning ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(isRunning ? .orange : .green)
                }
                
                Button(action: stopTimer) {
                    Image(systemName: "stop.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.red)
                }
            }
            
                // Preset Time Buttons
            HStack(spacing: 15) {
                ForEach([30, 60, 120, 300], id: \.self) { seconds in
                    Button(timeButtonLabel(seconds)) {
                        setTimer(to: Double(seconds))
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .background(Color.blue.opacity(0.2))
                    .foregroundColor(.blue)
                    .cornerRadius(10)
                    .disabled(isRunning)
                    .opacity(isRunning ? 0.5 : 1.0)
                }
            }
        }
        .padding()
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func timeString(from seconds: Double) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
    
    private func timeButtonLabel(_ seconds: Int) -> String {
        if seconds < 60 {
            return "\(seconds)s"
        } else if seconds < 3600 {
            return "\(seconds / 60)m"
        } else {
            return "\(seconds / 3600)h"
        }
    }
    
    private func toggleTimer() {
        if isRunning {
            pauseTimer()
        } else {
            startTimer()
        }
    }
    
    private func startTimer() {
        guard timeRemaining > 0 else { return }
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            withAnimation(.linear(duration: 0.1)) {
                if timeRemaining > 0 {
                    timeRemaining -= 0.1
                } else {
                    stopTimer()
                        // Timer finished - could add sound/haptic here
                }
            }
        }
    }
    
    private func pauseTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    private func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            timeRemaining = totalTime
        }
    }
    
    private func resetTimer() {
        stopTimer()
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            timeRemaining = totalTime
        }
    }
    
    private func setTimer(to seconds: Double) {
        totalTime = seconds
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            timeRemaining = seconds
        }
    }
    
    private func colorForTime() -> Color {
        let progress = timeRemaining / totalTime
        if progress > 0.5 {
            return .green
        } else if progress > 0.2 {
            return .orange
        } else {
            return .red
        }
    }
}

#Preview {
    AnimatedTimer()
}
