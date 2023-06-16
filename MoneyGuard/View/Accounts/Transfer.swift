//
//  Transfer.swift
//  MoneyGuard
//
//  Created by yury mid on 16.06.2023.
//

import SwiftUI

struct TransferView: View {
    private let tool: ToolsManager = ToolsManager()
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var accountsManager: AccountsManager

    @State var defaultAccount: Account?
    @State var senderAccountIndex = 0
    
    @State var receiverAccountIndex = 0
    
    @State var transferAmount = ""

    @State var showErrorMessage = false

    var body: some View {
        ScrollView {
            VStack(spacing: 15){
                TransferAccountCard(selectedAccountIndex: $senderAccountIndex)
                    .environmentObject(accountsManager)
                    .padding(.top)
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.title)
                    .foregroundColor(.accentColor)
                TransferAccountCard(selectedAccountIndex: $receiverAccountIndex)
                    .environmentObject(accountsManager)
                    .padding(.bottom)
            }
            .background(.ultraThinMaterial.opacity(0.5))
            
            TextField("\(NSLocalizedString("word_amount", comment: ""))...", text: $transferAmount)
                .padding()
                .padding(.horizontal, 10)
                .background(.ultraThinMaterial)
                .cornerRadius(15)
                .keyboardType(.decimalPad)
                .padding()
            
            if showErrorMessage {
                Text("alert_not_enough_money")
                    .padding()
                    .foregroundColor(.red)
                    .font(.headline)
            }
            
            Button {
                makeTransfer()
            } label: {
                HStack{
                    Spacer()
                    Image(systemName: "arrowshape.zigzag.right")
                    Text("btn_submit")
                    Spacer()
                }
                .padding()
                .font(.headline)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(15)
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .navigationTitle("btn_transfer")
        .onAppear {
            if let selectedAccount = defaultAccount {
                senderAccountIndex = accountsManager.accountList.firstIndex(of: selectedAccount) ?? 0
                if senderAccountIndex < accountsManager.accountList.count - 1 {
                    receiverAccountIndex = senderAccountIndex + 1
                } else {
                    receiverAccountIndex = 0
                }
            } else {
                senderAccountIndex = 0
                receiverAccountIndex = 0
            }
        }

    }
    
    private func makeTransfer() {
        let amount = Double(transferAmount)
        guard senderAccountIndex >= 0 && senderAccountIndex < accountsManager.accountList.count else {
            return
        }
        
        guard receiverAccountIndex >= 0 && receiverAccountIndex < accountsManager.accountList.count else {
            return
        }
        
        var senderAccount = accountsManager.accountList[senderAccountIndex]
        var receiverAccount = accountsManager.accountList[receiverAccountIndex]
        
        if senderAccount.balance >= amount ?? 0 {
            senderAccount.balance -= amount ?? 0
            receiverAccount.balance += amount ?? 0
            accountsManager.updateAccount()
            
            accountsManager.getAccountsList()
            showErrorMessage = false
            presentationMode.wrappedValue.dismiss()
        } else {
            showErrorMessage = true
        }
    }

}

struct TransferAccountCard: View {
    private let tool: ToolsManager = ToolsManager()
    @EnvironmentObject var accountsManager: AccountsManager
    
    @Binding var selectedAccountIndex: Int

    var selectedAccount: Account? {
        accountsManager.accountList[selectedAccountIndex]
    }
    
    var body: some View {
        VStack(alignment: .trailing) {
            HStack {
                if let account = selectedAccount {
                    Image(account.icon ?? "default")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .padding(10)

                    Spacer()

                    VStack(alignment: .trailing) {
                        Picker(selection: $selectedAccountIndex, label: Text("accounts_tab_account")) {
                            ForEach(Array(accountsManager.accountList.enumerated()), id: \.0) { index, account in
                                Text(account.name ?? "").tag(index)
                            }
                        }

                        Text("\(tool.formatCurrency(account.balance) ?? "")")
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
    }
}

struct TransferView_Previews: PreviewProvider {
    static var previews: some View {
        TransferView()
    }
}
