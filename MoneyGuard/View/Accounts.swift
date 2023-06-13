//
//  AccountsView.swift
//  MoneyGuard
//
//  Created by yury mid on 06.06.2023.
//

import SwiftUI

struct AccountsView: View {
    private let tool: ToolsManager = ToolsManager()
    let accounts: [SampleAccountModel] = [
        SampleAccountModel(name: "Kaspi Gold", icon: "ball", createDate: Date(), lastActivity: Date(), balance: 1000.0),
        SampleAccountModel(name: "Jusan Bang", icon: "heal", createDate: Date(), lastActivity: Date(), balance: 2500.0),
        SampleAccountModel(name: "Binance", icon: "award", createDate: Date(), lastActivity: Date(), balance: 500.0),
        SampleAccountModel(name: "MetaMask", icon: "love", createDate: Date(), lastActivity: Date(), balance: 1234567891.0)
    ]
    
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
                        NavigationLink(destination: AccountDetailView(account: account)) {
                            AccountCardView(account: account)
                        }
                    }
                }
                .padding(16)
            }
            .navigationTitle("accounts_tab")
        }
    }
}


struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsView()
    }
}
