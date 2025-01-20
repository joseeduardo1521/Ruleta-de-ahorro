//
//  ContentView.swift
//  Ruleta
//
//  Created by Jose  Olmos Oropeza on 19/01/25.
//

import SwiftUI


struct ContentView: View {
    @State private var selectedTab = 0
    @State private var savingsHistory: [SavingsEntry] = UserDefaultsManager.loadHistory()
    @State private var currentSavings: Int = UserDefaultsManager.loadCurrentSavings()
    @State private var savingsGoal: Int = UserDefaultsManager.loadSavingsGoal()

    var body: some View {
        TabView(selection: $selectedTab) {
            SavingsWheelView(savingsHistory: $savingsHistory, currentSavings: $currentSavings)
                .tabItem {
                    Label("Ruleta", systemImage: "circle")
                }
                .tag(0)

            SavingsHistoryView(savingsHistory: $savingsHistory)
                .tabItem {
                    Label("Historial", systemImage: "clock")
                }
                .tag(1)

            SavingsGoalsView(currentSavings: $currentSavings, savingsGoal: $savingsGoal)
                .tabItem {
                    Label("Metas", systemImage: "flag")
                }
                .tag(2)
        }
        .onChange(of: savingsHistory) { newValue in
            UserDefaultsManager.saveHistory(newValue)
        }
        .onChange(of: currentSavings) { newValue in
            UserDefaultsManager.saveCurrentSavings(newValue)
        }
        .onChange(of: savingsGoal) { newValue in
            UserDefaultsManager.saveSavingsGoal(newValue)
        }
    }
}


#Preview {
    ContentView()
}
