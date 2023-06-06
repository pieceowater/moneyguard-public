//
//  MoneyGuardApp.swift
//  MoneyGuard
//
//  Created by yury mid on 05.06.2023.
//

import SwiftUI

@main
struct MoneyGuardApp: App {

    @ObservedObject var userSettings = UserSettingsManager.shared
    @Environment(\.colorScheme) private var colorScheme
    var body: some Scene {
        WindowGroup {
            ContentView(userSettings: userSettings)
                .accentColor(userSettings.accentColor.color)
                .preferredColorScheme(userSettings.theme == .dark ? .dark : .light)
        }
    }
}
