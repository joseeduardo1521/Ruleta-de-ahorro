//
//  RuletaApp.swift
//  Ruleta
//
//  Created by Jose  Olmos Oropeza on 19/01/25.
//

import SwiftUI

// Modelo para los ahorros
struct SavingsEntry: Codable, Identifiable, Equatable {
    let id: UUID
    let date: String
    let amount: Int
}


@main
struct RuletaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}



struct SavingsWheelView: View {
    @Binding var savingsHistory: [SavingsEntry]
    @Binding var currentSavings: Int
    @State private var rotation: Double = 0
    @State private var result: Int? = nil
    let savingsOptions = [10, 20, 50, 100, 150, 200]

    var body: some View {
        VStack {
            Text("Ruleta para ahorrar")
                .font(.largeTitle)
                .padding()

            Spacer()

            ZStack {
                Circle()
                    .stroke(Color.blue, lineWidth: 5)
                    .frame(width: 250, height: 250)

                ForEach(0..<savingsOptions.count) { index in
                    let angle = Angle(degrees: Double(index) / Double(savingsOptions.count) * 360)
                    VStack {
                        Text("$\(savingsOptions[index])")
                            .font(.headline)
                            .rotationEffect(-angle)
                        Spacer()
                    }
                    .frame(width: 125, height: 125)
                    .rotationEffect(angle)
                }
            }
            .rotationEffect(Angle(degrees: rotation))
            .animation(.easeOut(duration: 2), value: rotation)

            Button(action: spinWheel) {
                Text("Girar")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            if let result = result {
                Text("Hoy debes ahorrar: $\(result)")
                    .font(.title)
                    .padding()
            }

            Spacer()
        }
    }

    func spinWheel() {
        let randomIndex = Int.random(in: 0..<savingsOptions.count)
        let randomRotation = Double.random(in: 720...1080) + (Double(randomIndex) / Double(savingsOptions.count) * 360)

        rotation += randomRotation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let amount = savingsOptions[randomIndex]
            result = amount

            // Add to history and update savings
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.string(from: Date())

            let entry = SavingsEntry(id: UUID(), date: date, amount: amount)
            savingsHistory.append(entry)
            currentSavings += amount
        }
    }
}

struct SavingsHistoryView: View {
    @Binding var savingsHistory: [SavingsEntry]

    var body: some View {
        VStack {
            Text("Historial de ahorros")
                .font(.largeTitle)
                .padding()

            List(savingsHistory) { entry in
                HStack {
                    Text(entry.date)
                        .font(.headline)
                    Spacer()
                    Text("$\(entry.amount)")
                        .font(.body)
                }
            }
        }
    }
}

struct SavingsGoalsView: View {
    @Binding var currentSavings: Int
    @Binding var savingsGoal: Int

    var body: some View {
        VStack {
            Text("Metas de ahorro")
                .font(.largeTitle)
                .padding()

            Text("Progreso de la meta")
                .font(.headline)

            ProgressView(value: Double(currentSavings), total: Double(savingsGoal))
                .padding()

            Text("$\(currentSavings) / $\(savingsGoal)")
                .font(.body)

            Spacer()

            HStack {
                Text("Meta de ahorro: ")
                TextField("Ingrese meta", value: $savingsGoal, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .frame(width: 100)
            }
            .padding()

            Spacer()
        }
    }
}

class UserDefaultsManager {
    private static let historyKey = "savingsHistory"
    private static let currentSavingsKey = "currentSavings"
    private static let savingsGoalKey = "savingsGoal"

    static func loadHistory() -> [SavingsEntry] {
        guard let data = UserDefaults.standard.data(forKey: historyKey),
              let decoded = try? JSONDecoder().decode([SavingsEntry].self, from: data) else {
            return []
        }
        return decoded
    }

    static func saveHistory(_ history: [SavingsEntry]) {
        if let encoded = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(encoded, forKey: historyKey)
        }
    }

    static func loadCurrentSavings() -> Int {
        return UserDefaults.standard.integer(forKey: currentSavingsKey)
    }

    static func saveCurrentSavings(_ amount: Int) {
        UserDefaults.standard.set(amount, forKey: currentSavingsKey)
    }

    static func loadSavingsGoal() -> Int {
        return UserDefaults.standard.integer(forKey: savingsGoalKey)
    }

    static func saveSavingsGoal(_ goal: Int) {
        UserDefaults.standard.set(goal, forKey: savingsGoalKey)
    }
}
