    //
    //  ContentView.swift
    //  BetterRest
    //
    //  Created by Hafizur Rahman on 5/11/25.
    //

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUpTime = defaultWakeUpTime
    @State private var sleepHours = 8.0
    @State private var coffeeAmount = 1
    
    @State private var isAlertVisible = false
    @State private var isExpanded = true
    
    static var defaultWakeUpTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var recommendedBedtime: String {
        calculateBedTime()
    }
    
    var body: some View {
        NavigationStack {
            
            Form {
                DisclosureGroup(isExpanded: $isExpanded) {
                    DatePicker("Pick a time", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                } label: {
                    Text("When do you want to wake up?")
                        .font(.headline)
                }
                
                Section("Desired amount of sleep", isExpanded: $isExpanded, content: {
                    Text("Desired amount of sleep").font(.headline)
                    
                    Stepper("\(sleepHours.formatted())",value: $sleepHours, in: 4...12, step: 0.25)
                } )
                
                
                
                Picker("Daily coffee intake", selection: $coffeeAmount) {
                    ForEach(1...20, id: \.self) { number in
                        Text("^[\(number) cup](inflect: true)")
                    }
                    
                }
                .customVStack()
                
                Section("Your ideal bedtime") {
                    Text(recommendedBedtime)
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical)
                }
            }
            .navigationTitle("BetterRest")
        }
    }
    
    
    func calculateBedTime() -> String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUpTime)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepHours, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUpTime - prediction.actualSleep
            return sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            return "Faild to calculate"
        }
    }
}

#Preview {
    ContentView()
}


struct CustomVStack: ViewModifier {
    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            content
        }
    }
}

extension View {
    func customVStack() -> some View {
        self.modifier(CustomVStack())
    }
}
