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
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        Text(tool.formatCurrency(accountsManager.accountList.reduce(0, { $0 + $1.balance })) ?? "")
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
                    ForEach(Array(accountsManager.accountList.enumerated()), id: \.1) { index, account in
                        NavigationLink(destination: AccountDetailView(accounts: accountsManager.accountList, account: index)) {
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
                CreateAccountView(accounts: $accountsManager.accountList)
                    .environmentObject(accountsManager)
                    .accentColor(userSettings.accentColor.color)
            })
            .navigationTitle("accounts_tab")
            .onAppear{
                print("Appear")
            }
        }
    }
}


struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsView()
    }
}
