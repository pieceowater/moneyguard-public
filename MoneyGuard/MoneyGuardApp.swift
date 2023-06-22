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
    
    let slides = [
        Slide(imageName: "MoneyGuard", title: NSLocalizedString("slideshow_title_1", comment: ""), description: NSLocalizedString("slideshow_description_1", comment: "")),
        Slide(imageName: "help", title: NSLocalizedString("slideshow_title_2", comment: ""), description: NSLocalizedString("slideshow_description_2", comment: "")),
        Slide(imageName: "award", title: NSLocalizedString("slideshow_title_3", comment: ""), description: NSLocalizedString("slideshow_description_3", comment: "")),
        Slide(imageName: "rainbow", title: NSLocalizedString("slideshow_title_4", comment: ""), description: NSLocalizedString("slideshow_description_4", comment: ""))
    ]
    
    @State var isShowingSlideShow: Bool = false

    var body: some Scene {
        WindowGroup {
            ContentView(userSettings: userSettings)
                .onAppear{
                    checkFirstLaunch()
                }
                .fullScreenCover(isPresented: $isShowingSlideShow) {
                    SlideshowView(slides: slides)
                        .accentColor(userSettings.accentColor.color)
                }
                .accentColor(userSettings.accentColor.color)
                .preferredColorScheme(userSettings.theme == .dark ? .dark : .light)
                .environmentObject(transactionsManager)
                .environmentObject(goalsManager)
                .environmentObject(accountsManager)
                .environmentObject(categoriesManager)
        }
    }
    
    func checkFirstLaunch() {
        let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        
        if !isFirstLaunch {
            isShowingSlideShow = true
            accountsManager.createAccount(accountName: NSLocalizedString("first_account_name", comment: ""), accountIcon: "default", accountBalance: 0.0)
            accountsManager.getAccountsList()
            categoriesManager.createCategory(categoryName: NSLocalizedString("first_category_replanishments_name", comment: ""), categoryIcon: "default2", categoryColor: "Green", categoryEssentialDegree: 2, categoryType: "replenishments")
            categoriesManager.createCategory(categoryName: NSLocalizedString("first_category_expenses_name", comment: ""), categoryIcon: "default3", categoryColor: "Teal", categoryEssentialDegree: 2, categoryType: "expenses")

            categoriesManager.createCategory(categoryName: NSLocalizedString("system_account_transfer_from", comment: ""), categoryIcon: "debt", categoryColor: "Green", categoryEssentialDegree: 2, categoryType: "transferFrom")
            categoriesManager.createCategory(categoryName: NSLocalizedString("system_account_transfer_to", comment: ""), categoryIcon: "debt", categoryColor: "Red", categoryEssentialDegree: 2, categoryType: "transferTo")
            categoriesManager.getCategoriessList()
            
            UserDefaults.standard.set(true, forKey: "isFirstLaunch")
        }
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


struct SlideshowView: View {
    @Environment(\.presentationMode) var presentationMode
    let slides: [Slide]
    @State private var currentIndex = 0
    
    var body: some View {
        VStack {
            Spacer()
            Image(slides[currentIndex].imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(slides[currentIndex].imageName == "MoneyGuard" ? 40 : 0)
                .padding(80)
            
            Text(slides[currentIndex].title)
                .foregroundColor(.accentColor)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()
                
            
            Text(slides[currentIndex].description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
            
            HStack {
                Button(action: {
                    withAnimation {
                        currentIndex = max(currentIndex - 1, 0)
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                }
                .disabled(currentIndex == 0)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        if currentIndex == slides.count - 1 {
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            currentIndex = min(currentIndex + 1, slides.count - 1)
                        }
                    }
                }) {
                    Image(systemName: "\(currentIndex == slides.count - 1 ? "arrow" : "chevron" ).right")
                        .font(.title)
                }
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

struct Slide {
    let imageName: String
    let title: String
    let description: String
}

