//
//  HomeView.swift
//  MoneyGuard
//
//  Created by yury mid on 06.06.2023.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userSettings: UserSettingsManager
    @EnvironmentObject var accountManager: AccountsManager
    
    private let tool: ToolsManager = ToolsManager()
    @State var accounts: [Account] = []
    
    @State private var selectedReportPeriod = 1
    
    @State private var transactions: [SampleTransaction] = [
        SampleTransaction(date: Date(), value: 1000.0, account: SampleAccountModel(name: "Kaspi", icon: "ball", createDate: Date(), lastActivity: Date(), balance: 100000.0), category: SampleCategoryModel(name: "Food", color: "Blue", createDate: Date(), lastActivity: Date(), icon: "pizza", type: "expenses", essentialDegree: 3)),
        SampleTransaction(date: Date(), value: 2000.0, account: SampleAccountModel(name: "Kaspi", icon: "ball", createDate: Date(), lastActivity: Date(), balance: 100000.0), category: SampleCategoryModel(name: "Food", color: "Red", createDate: Date(), lastActivity: Date(), icon: "pizza", type: "expenses", essentialDegree: 3)),
        SampleTransaction(date: Date(), value: 3000.0, account: SampleAccountModel(name: "Kaspi", icon: "ball", createDate: Date(), lastActivity: Date(), balance: 100000.0), category: SampleCategoryModel(name: "Food", color: "Green", createDate: Date(), lastActivity: Date(), icon: "pizza", type: "expenses", essentialDegree: 3)),
        SampleTransaction(date: Date(), value: 4000.0, account: SampleAccountModel(name: "Kaspi", icon: "ball", createDate: Date(), lastActivity: Date(), balance: 100000.0), category: SampleCategoryModel(name: "Food", color: "Blue", createDate: Date(), lastActivity: Date(), icon: "pizza", type: "expenses", essentialDegree: 3)),
        SampleTransaction(date: Date(), value: 5000.0, account: SampleAccountModel(name: "Kaspi", icon: "ball", createDate: Date(), lastActivity: Date(), balance: 100000.0), category: SampleCategoryModel(name: "Food", color: "Red", createDate: Date(), lastActivity: Date(), icon: "pizza", type: "expenses", essentialDegree: 3)),
        SampleTransaction(date: Date(), value: 6000.0, account: SampleAccountModel(name: "Kaspi", icon: "ball", createDate: Date(), lastActivity: Date(), balance: 100000.0), category: SampleCategoryModel(name: "Food", color: "Green", createDate: Date(), lastActivity: Date(), icon: "pizza", type: "expenses", essentialDegree: 3)),
        SampleTransaction(date: Date(), value: 7000.0, account: SampleAccountModel(name: "Kaspi", icon: "ball", createDate: Date(), lastActivity: Date(), balance: 100000.0), category: SampleCategoryModel(name: "Food", color: "Green", createDate: Date(), lastActivity: Date(), icon: "pizza", type: "expenses", essentialDegree: 3)),
        SampleTransaction(date: Date(), value: 8000.0, account: SampleAccountModel(name: "Kaspi", icon: "ball", createDate: Date(), lastActivity: Date(), balance: 100000.0), category: SampleCategoryModel(name: "Food", color: "Green", createDate: Date(), lastActivity: Date(), icon: "pizza", type: "expenses", essentialDegree: 3)),
        SampleTransaction(date: Date(), value: 9000.0, account: SampleAccountModel(name: "Kaspi", icon: "ball", createDate: Date(), lastActivity: Date(), balance: 100000.0), category: SampleCategoryModel(name: "Food", color: "Green", createDate: Date(), lastActivity: Date(), icon: "pizza", type: "expenses", essentialDegree: 3)),
        SampleTransaction(date: Date(), value: 10000.0, account: SampleAccountModel(name: "Kaspi", icon: "ball", createDate: Date(), lastActivity: Date(), balance: 100000.0), category: SampleCategoryModel(name: "Food", color: "Green", createDate: Date(), lastActivity: Date(), icon: "pizza", type: "expenses", essentialDegree: 3)),
        SampleTransaction(date: Date(), value: 11000.0, account: SampleAccountModel(name: "Kaspi", icon: "ball", createDate: Date(), lastActivity: Date(), balance: 100000.0), category: SampleCategoryModel(name: "Food", color: "Green", createDate: Date(), lastActivity: Date(), icon: "pizza", type: "expenses", essentialDegree: 3)),
        SampleTransaction(date: Date(), value: 12000.0, account: SampleAccountModel(name: "Kaspi", icon: "ball", createDate: Date(), lastActivity: Date(), balance: 100000.0), category: SampleCategoryModel(name: "Food", color: "Green", createDate: Date(), lastActivity: Date(), icon: "pizza", type: "expenses", essentialDegree: 3)),
        SampleTransaction(date: Date(), value: 13000.0, account: SampleAccountModel(name: "Kaspi", icon: "ball", createDate: Date(), lastActivity: Date(), balance: 100000.0), category: SampleCategoryModel(name: "Food", color: "Green", createDate: Date(), lastActivity: Date(), icon: "pizza", type: "expenses", essentialDegree: 3))
    ]
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .trailing) {
                    HStack{
                        if let selectedUUID = userSettings.selectedAccountID {
                            if let account = accounts.first(where: { $0.id == selectedUUID }) {
                                Image(account.icon ?? "default")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .padding(10)
                                    
                            } else {
                                Image("default")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .padding(10)
                            }
                        } else {
                            Image("default")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .padding(10)
                        }
                        
                        Spacer()
                        
                        VStack (alignment: .trailing){
                            
                            Picker(selection: $userSettings.selectedAccountID, label: Text("accounts_tab_account")) {
                                Text("accounts_tab_all_accounts").tag(nil as UUID?)
                                ForEach(accounts.sorted(by: { $0.lastActivity ?? Date() > $1.lastActivity ?? Date() }), id: \.id) { account in
                                    Text(account.name ?? "")
                                        .tag(account.id)
                                }
                            }
                            .onChange(of: userSettings.selectedAccountID) { newSelectedAccountID in
                                userSettings.saveSelectedAccount()
                            }
                            
                            
                            if let selectedUUID = userSettings.selectedAccountID {
                                if let account = accounts.first(where: { $0.id == selectedUUID }) {
                                    Text("\(tool.formatCurrency(Double(account.balance)) ?? "")")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                        .foregroundColor(.accentColor)
                                        .padding(.horizontal)
                                } else {
                                    Text("\(tool.formatCurrency(0) ?? "")")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                        .foregroundColor(.accentColor)
                                        .padding(.horizontal)
                                }
                            } else {
                                let totalBalance = accounts.reduce(0) { $0 + ($1.balance ?? 0) }
                                Text("\(tool.formatCurrency(Double(totalBalance)) ?? "")")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                    .foregroundColor(.accentColor)
                                    .padding(.horizontal)
                            }


                               
                        }
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                .padding(.horizontal)
                .padding(.top)
                
                HomeOverviewSectionView(selectedReportPeriod: $selectedReportPeriod, transactions: $transactions)
                
                
            }.overlay(alignment: .trailing) {
                VStack {
                    Spacer()
                    Button(action: {
                        giveHapticFeedback()
                    }) {
                        Image(systemName: "plus").foregroundColor(.accentColor)
                            .font(.title)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(100)
                            .shadow(color: .black.opacity(0.2), radius: 2, x: 2, y: 2)
                    }
                    .padding(.trailing, 30)
                    .padding(.bottom, 20)
                }
            }
            .onAppear{
                accounts = accountManager.accountList
            }
            .navigationTitle("app_name")
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

