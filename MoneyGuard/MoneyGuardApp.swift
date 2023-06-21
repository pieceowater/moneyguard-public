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
                .onAppear{
                    checkFirstLaunch()
                }
        }
    }
    
    func checkFirstLaunch() {
        let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        
        if !isFirstLaunch {
            accountsManager.createAccount(accountName: NSLocalizedString("first_account_name", comment: ""), accountIcon: "default", accountBalance: 0.0)
            accountsManager.getAccountsList()
            categoriesManager.createCategory(categoryName: NSLocalizedString("first_category_replanishments_name", comment: ""), categoryIcon: "default2", categoryColor: "Green", categoryEssentialDegree: 2, categoryType: "replenishments")
            categoriesManager.createCategory(categoryName: NSLocalizedString("first_category_expenses_name", comment: ""), categoryIcon: "default3", categoryColor: "Teal", categoryEssentialDegree: 2, categoryType: "expenses")
            categoriesManager.getCategoriessList()
            
            UserDefaults.standard.set(true, forKey: "isFirstLaunch")
        }
        
        print(!isFirstLaunch)
    }
}


struct HideKeyboardOnTap: ViewModifier {
    @Environment(\.editMode) private var editMode
    @Environment(\.isKeyboardVisible) private var isKeyboardVisible
    @Environment(\.endEditing) private var endEditing
    
    let excludedViews: [AnyView]
    
    init(excluding views: [AnyView]) {
        self.excludedViews = views
    }
    
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                guard !isExcludedViewTapped() else { return }
                endEditing()
            }
    }
    
    private func isExcludedViewTapped() -> Bool {
        for view in excludedViews {
            if view is TextField<AnyView> || view is TextEditor {
                return true
            }
        }
        return false
    }
}



struct IsKeyboardVisibleKey: EnvironmentKey {
    static let defaultValue: Binding<Bool>? = nil
}

extension EnvironmentValues {
    var isKeyboardVisible: Binding<Bool>? {
        get { self[IsKeyboardVisibleKey.self] }
        set { self[IsKeyboardVisibleKey.self] = newValue }
    }
}

struct EndEditingKey: EnvironmentKey {
    static let defaultValue: () -> Void = { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) }
}

extension EnvironmentValues {
    var endEditing: () -> Void {
        get { self[EndEditingKey.self] }
        set { self[EndEditingKey.self] = newValue }
    }
}

extension View {
    func hideKeyboardOnTap(excluding views: [AnyView]) -> some View {
        self.modifier(HideKeyboardOnTap(excluding: views))
    }
}
