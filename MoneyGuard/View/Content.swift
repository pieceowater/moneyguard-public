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
    
    @State private var selectedTab: Tab = .menu

    enum Tab {
        case menu
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            MenuView()
                .environmentObject(userSettings)
                .tabItem {
                    Label("menu_tab", systemImage: "list.dash")
                }
                .tag(Tab.menu)
            
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(userSettings: UserSettingsManager.shared)
    }
}
