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
    @EnvironmentObject var transactionManager: TransactionManager
    
    private let tool: ToolsManager = ToolsManager()
    @State var accounts: [Account] = []
    
    @State private var selectedReportPeriod = 1
    
    @State private var showNewTransactionSheet = false
    
    @State private var transactions: [Transaction] = []
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                if accountManager.accountList.count == 0 {
                    VStack(spacing: 25){
                        Image("MoneyGuard")
                            .resizable()
                            .frame(width: 200, height: 200)
                            .cornerRadius(35)
                        Text("placeholder_message_no_accounts")
                            .multilineTextAlignment(.center)
                            .font(.headline)
                            
                    }.padding(.vertical, 100)
                }else {
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
                                    ForEach(accounts.sorted(by: { $0.lastActivity ?? Date() > $1.lastActivity ?? Date() }), id: \.id) { account in
                                        Text(account.name ?? "")
                                            .tag(account.id)
                                    }
                                }
                                .onChange(of: userSettings.selectedAccountID) { newSelectedAccountID in
                                    userSettings.saveSelectedAccount()
                                    transactions = transactionManager.transactionsList.filter { $0.account?.id == UserSettingsManager.shared.selectedAccountID }.sorted(by: { $0.date ?? Date() > $1.date ?? Date() })
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
//                                    let totalBalance = accounts.reduce(0) { $0 + ($1.balance ) }
//                                    Text("\(tool.formatCurrency(Double(totalBalance)) ?? "")")
//                                        .font(.title2)
//                                        .fontWeight(.bold)
//                                        .lineLimit(1)
//                                        .minimumScaleFactor(0.5)
//                                        .foregroundColor(.accentColor)
//                                        .padding(.horizontal)
                                    }
                                } else {
//                                let totalBalance = accounts.reduce(0) { $0 + ($1.balance ) }
//                                Text("\(tool.formatCurrency(Double(totalBalance)) ?? "")")
//                                    .font(.title2)
//                                    .fontWeight(.bold)
//                                    .lineLimit(1)
//                                    .minimumScaleFactor(0.5)
//                                    .foregroundColor(.accentColor)
//                                    .padding(.horizontal)
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
                }
                
                
                
                
            }.overlay(alignment: .trailing) {
                if accountManager.accountList.count != 0 {
                    VStack {
                        Spacer()
                        Button(action: {
                            giveHapticFeedback()
                            showNewTransactionSheet = true
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
            }
            .sheet(isPresented: $showNewTransactionSheet, content: {
                NewTransactionView().accentColor(userSettings.accentColor.color)
            })
            .onAppear{
                transactions = transactionManager.transactionsList.filter { $0.account?.id == UserSettingsManager.shared.selectedAccountID }.sorted(by: { $0.date ?? Date() > $1.date ?? Date() })
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

