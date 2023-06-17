//
//  ContentView.swift
//  MoneyGuard
//
//  Created by yury mid on 05.06.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @ObservedObject var userSettings: UserSettingsManager
    
    @EnvironmentObject var accountsManager: AccountsManager
    @EnvironmentObject var categoriesManager: CategoryManager
    
    @State private var selectedTab: Tab = .home

    enum Tab {
        case home
        case goals
        case accounts
        case stats
        case menu
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            StatsView()
                .tabItem {
                    Label("stats_tab", systemImage: "chart.bar.fill")
                }
                .tag(Tab.stats)
            GoalsView()
                .tabItem {
                    Label("goals_tab", systemImage: "star.fill")
                }
                .tag(Tab.goals)
            HomeView()
                .environmentObject(userSettings)
                .environmentObject(accountsManager)
                .environmentObject(categoriesManager)
                .tabItem {
                    Label("home_tab", systemImage: "house.fill")
                }
                .tag(Tab.home)
            AccountsView()
                .environmentObject(userSettings)
                .environmentObject(accountsManager)
                .tabItem {
                    Label("accounts_tab", systemImage: "creditcard.fill")
                }
                .tag(Tab.accounts)
            MenuView()
                .environmentObject(userSettings)
                .environmentObject(categoriesManager)
                .tabItem {
                    Label("menu_tab", systemImage: "list.bullet.circle.fill")
                }
                .tag(Tab.menu)
            
        }
    }

}

func giveHapticFeedback() {
    let generator = UIImpactFeedbackGenerator(style: .light)
    generator.prepare()
    generator.impactOccurred()
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(userSettings: UserSettingsManager.shared)
            .environmentObject(AccountsManager())
    }
}
