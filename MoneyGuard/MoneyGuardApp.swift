//
//  MoneyGuardApp.swift
//  MoneyGuard
//
//  Created by yury mid on 05.06.2023.
//

import SwiftUI

@main
struct MoneyGuardApp: App {
    @ObservedObject var transactionsManager: TransactionManager = TransactionManager()
    @ObservedObject var goalsManager: GoalsManager = GoalsManager()
    @ObservedObject var accountsManager: AccountsManager = AccountsManager()
    @ObservedObject var categoriesManager: CategoryManager = CategoryManager()

    @ObservedObject var userSettings = UserSettingsManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView(userSettings: userSettings)
                .accentColor(userSettings.accentColor.color)
                .preferredColorScheme(userSettings.theme == .dark ? .dark : .light)
                .environmentObject(transactionsManager)
                .environmentObject(goalsManager)
                .environmentObject(accountsManager)
                .environmentObject(categoriesManager)
        }
    }
}
