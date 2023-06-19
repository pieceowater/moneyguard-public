//
//  TransactionDetail.swift
//  MoneyGuard
//
//  Created by yury mid on 19.06.2023.
//

import SwiftUI

struct TransactionDetailView: View {
    @EnvironmentObject var transactionManager: TransactionManager
    @Environment(\.presentationMode) var presentationMode
    private let tool: ToolsManager = ToolsManager()
    @State private var showAlert = false
    @State var transaction: Transaction
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("menu_settings_category_single")
                        .font(.headline)
                    HStack{
                        Image(transaction.category?.icon ?? "default")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text(transaction.category?.name ?? "")
                            .font(.headline)
                        Spacer()
                        
                        StarRatingView(rating: Int(transaction.category?.essentialDegree ?? 2))
                    }.padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                }.padding(.horizontal).padding(.bottom)
                
                VStack(alignment: .leading) {
                    Text("accounts_tab_account")
                        .font(.headline)
                    HStack{
                        Image(transaction.account?.icon ?? "default")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text(transaction.account?.name ?? "")
                            .font(.headline)
                        Spacer()
                        
                        Text(tool.formatCurrency(transaction.account?.balance ?? 0) ?? "")
                            .foregroundColor(.accentColor)
                            .font(.headline)
                    }.padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                }.padding(.horizontal).padding(.bottom)
                
                VStack(alignment: .leading) {
                    Text("word_amount")
                        .font(.headline)
                    Text("\(transaction.category?.type == "expenses" ? "-" : "+")\(tool.formatCurrency(transaction.value) ?? "")")
                        .font(.title)
                        .foregroundColor(transaction.category?.type == "expenses" ? .red : .green)
                }.padding(.horizontal).padding(.bottom)
                
                VStack(alignment: .leading) {
                    Text("word_date")
                        .font(.headline)
                    Text("\(tool.formatDate(transaction.date ?? Date()))")
                        .font(.title)
                        .foregroundColor(.accentColor)
                }.padding(.horizontal).padding(.bottom)
                
                if !(transaction.comment?.isEmpty ?? false) {
                    VStack(alignment: .leading) {
                        Text("home_new_transaction_comment")
                            .font(.headline)
                        Text(transaction.comment ?? "")
                            .font(.subheadline)
                            .italic()
                            .padding()
                    }.padding(.horizontal).padding(.bottom)
                }
            }
        }
        .toolbar {
            Button {
                showAlert = true
            } label: {
                Text("btn_delete")
                    .foregroundColor(.red)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("alert_confirm"),
                message: Text("alert_sure_msg"),
                primaryButton: .destructive(Text("alert_rm_btn"), action: {
                    //                    accountsManager.deleteAccount(account: account)
                    //                    accountsManager.getAccountsList()
                    transactionManager.deleteTransaction(transaction: transaction)
                    transactionManager.getTransactionList()
                    presentationMode.wrappedValue.dismiss()
                }),
                secondaryButton: .cancel()
            )
        }
    }
}

