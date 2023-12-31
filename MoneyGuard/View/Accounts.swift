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
    @EnvironmentObject var transactionManager: TransactionManager
    
    @State var accounts: [Account] = []
    
    @State var createAccountSheetShowing = false
    
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

                if accounts.count == 0 {
                    PlaceholderCreateAccountView(createAccountSheetShowing: $createAccountSheetShowing)
                        .padding(.vertical, 100)
                }else{
                    LazyVGrid(columns: [GridItem(.flexible())], spacing: 16) {
                        ForEach(accounts) { account in
                            NavigationLink(destination: AccountDetailView(account: account).environmentObject(transactionManager)) {
                                AccountCardView(account: account)
                            }
                        }
                        
                        Button {
                            giveHapticFeedback()
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
            }
            .sheet(isPresented: $createAccountSheetShowing, content: {
                CreateAccountView(accounts: $accounts)
                    .environmentObject(accountsManager)
                    .accentColor(userSettings.accentColor.color)
            })
            .navigationTitle("accounts_tab")
            .onAppear{
                accountsManager.getAccountsList()
                accounts = accountsManager.accountList
            }
            .onChange(of: accountsManager.accountList) { newValue in
                accounts = accountsManager.accountList
            }
        }
    }
}

struct PlaceholderCreateAccountView: View {
    @Binding var createAccountSheetShowing: Bool
    var body: some View {
        VStack(spacing: 25){
            Image("plant")
                .resizable()
                .frame(width: 200, height: 200)
                .cornerRadius(35)
            Text("placeholder_message_create_account")
                .multilineTextAlignment(.center)
                .font(.headline)
            
            Button {
                giveHapticFeedback()
                createAccountSheetShowing = true
            } label: {
                HStack{
                    Image(systemName: "plus.rectangle.on.rectangle")
                    Text("btn_add_new")
                }.padding()
            }
                
        }
    }
}
