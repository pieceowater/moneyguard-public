//
//  AccountDetailView.swift
//  MoneyGuard
//
//  Created by yury mid on 07.06.2023.
//

import SwiftUI

struct AccountDetailView: View {
    private let tool: ToolsManager = ToolsManager()
    let account: SampleAccountModel
    
    var body: some View {
        VStack {
//            Text(String(format: "Balance: $%.2f", account.balance))
            Text("\(tool.formatCurrency(account.balance) ?? "")")
                .font(.subheadline)
            Text("\(tool.formatDate(account.lastActivity))")
                .font(.subheadline)
            
            Text("WORK IN PROGRESS")
            
            Spacer()
        }
        .padding()
        .navigationTitle(account.name)
    }
}

struct AccountDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetailView(account: SampleAccountModel(name: "QWERTY", icon: "love", createDate: Date(), lastActivity: Date(), balance: 12345.0))
    }
}
