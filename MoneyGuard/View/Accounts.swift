//
//  AccountsView.swift
//  MoneyGuard
//
//  Created by yury mid on 06.06.2023.
//

import SwiftUI

struct SampleAccountModel: Identifiable {
    let id: UUID = UUID()
    let name: String
    let icon: String
    let createDate: Date
    let lastActivity: Date
    let balance: Double
}

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
            .refreshable {}
            .navigationTitle("accounts_tab")
        }
    }
}

struct AccountCardView: View {
    private let tool: ToolsManager = ToolsManager()
    let account: SampleAccountModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(account.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .padding(10)
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)

                VStack(alignment: .leading){
                    Text(account.name)
                        .font(.title3)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Text(tool.formatCurrency(account.balance) ?? "")
                        .font(.title)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }.padding(10)
                
                Spacer()
            }
            HStack{
                Text("\(tool.formatDate(account.lastActivity))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(5)
                Spacer()
                
                HStack{
                    Text("btn_open")
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.secondary)
                .font(.body)
            }
        }
        .padding(15)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
    
}


struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsView()
    }
}
