//
//  UserSettingsManager.swift
//  MoneyGuard
//
//  Created by yury mid on 06.06.2023.
//

import Foundation
import SwiftUI

class UserSettingsManager: ObservableObject {
    static let shared = UserSettingsManager()
    
    @Published var accentColor: Colors = .default
    @Published var selectedAccountID: UUID?
    @Published var theme: Theme = .light
    @Published var selectedLanguage: Language?
    
    private let accentColorKey = "accentColor"
    private let themeKey = "theme"
    
    private init() {
        loadSettings()
    }
    
    func saveSelectedAccount() {
        if let selectedAccountID = selectedAccountID {
            let selectedAccountIDValue = selectedAccountID.uuidString
            UserDefaults.standard.set(selectedAccountIDValue, forKey: "SelectedAccountID")
        } else {
            UserDefaults.standard.removeObject(forKey: "SelectedAccountID")
        }
    }
    
    func resetSelectedAccount() {
        UserDefaults.standard.removeObject(forKey: "SelectedAccountID")
        loadSettings()
    }
    
    func saveSettings() {
        UserDefaults.standard.set(accentColor.rawValue, forKey: accentColorKey)
        UserDefaults.standard.set(theme.rawValue, forKey: themeKey)
    }
    
    func setLanguage(_ language: Language) {
        selectedLanguage = language

        // Update the app's localization
        UserDefaults.standard.set([language.code], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
    
    private func loadSettings() {
        
        if let selectedAccountIDValue = UserDefaults.standard.string(forKey: "SelectedAccountID") {
            if let selectedAccountID = UUID(uuidString: selectedAccountIDValue) {
                self.selectedAccountID = selectedAccountID
            }
        }
        
        if let accentColorValue = UserDefaults.standard.string(forKey: accentColorKey),
           let accentColor = Colors(rawValue: accentColorValue) {
            self.accentColor = accentColor
        }
        
        if let themeValue = UserDefaults.standard.string(forKey: themeKey),
           let theme = Theme(rawValue: themeValue) {
            self.theme = theme
        }
    }
    
    func resetSettings() {
        UserDefaults.standard.removeObject(forKey: accentColorKey)
        UserDefaults.standard.removeObject(forKey: themeKey)
        loadSettings()
    }
}

enum Theme: String {
    case light
    case dark
}

enum Colors: String, CaseIterable {
    case blue
    case red
    case orange
    case purple
    case pink
    case teal
    case `default`
    
    var color: Color {
        switch self {
        case .blue:
            return .blue
        case .red:
            return .red
        case .orange:
            return .orange
        case .purple:
            return .purple
        case .pink:
            return .pink
        case .teal:
            return .teal
        case .default:
            return Color(hex: "61C554")
        }
    }
}




extension Color {
    init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        if hexString.count != 6 {
            self.init(.gray)
            return
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
    
    static var customBlue: Color { Color("Blue") }
    static var customGreen: Color { Color("Green") }
    static var customRed: Color { Color("Red") }
    static var customPurple: Color { Color("Purple") }
    static var customOrange: Color { Color("Orange") }
    static var customYellow: Color { Color("Yellow") }
    static var customPink: Color { Color("Pink") }
    static var customTeal: Color { Color("Teal") }
    static var customIndigo: Color { Color("Indigo") }
    static var customBrown: Color { Color("Brown") }
    static var customGray: Color { Color("Gray") }
    static var customCyan: Color { Color("Cyan") }
    static var customLavender: Color { Color("Lavender") }
    static var customAmber: Color { Color("Amber") }
    static var customMaroon: Color { Color("Maroon") }
}

enum CategoryColor: String, CaseIterable {
    case Blue
    case Green
    case Red
    case Purple
    case Orange
    case Yellow
    case Pink
    case Teal
    case Indigo
    case Brown
    case Gray
    case Cyan
    case Lavender
    case Amber
    case Maroon
    
    var color: Color {
        guard let colorName = self.rawValue as String? else {
            return Color.clear
        }
        return Color(colorName)
    }
}
