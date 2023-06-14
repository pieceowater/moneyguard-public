//
//  AccountsView.swift
//  MoneyGuard
//
//  Created by yury mid on 06.06.2023.
//

import SwiftUI

struct AccountsView: View {
    private let tool: ToolsManager = ToolsManager()
    @EnvironmentObject var userSettings: UserSettingsManager
    @EnvironmentObject var accountsManager: AccountsManager
    
    @State private var createAccountSheetShowing = false
    
    @State private var accounts: [Account] = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        Text(tool.formatCurrency(accounts.reduce(0, { $0 + $1.balance })) ?? "")
                            .font(.title2)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .foregroundColor(.accentColor)
                        Spacer()
                    }
                    .padding(.horizontal)
                }

                LazyVGrid(columns: [GridItem(.flexible())], spacing: 16) {
                    ForEach(accounts) { account in
                        NavigationLink(destination: AccountDetailView(accounts: $accounts, account: account)) {
                            AccountCardView(account: account)
                        }
                    }

                    Button {
                        createAccountSheetShowing = true
                    } label: {
                        HStack{
                            Image(systemName: "plus.rectangle.on.rectangle")
                            Text("btn_add_new")
                        }.padding()
                    }
                }
                .padding(16)
            }
            .sheet(isPresented: $createAccountSheetShowing, content: {
                CreateAccountView(accounts: $accounts)
                    .environmentObject(accountsManager)
                    .accentColor(userSettings.accentColor.color)
            })
            .navigationTitle("accounts_tab")
            .onAppear{
                accounts = accountsManager.accountList
            }
            .onChange(of: accounts) { newValue in
                accounts = accountsManager.accountList
            }
        }
    }
}


struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsView()
    }
}
