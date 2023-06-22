//
//  SavingsCardDetail.swift
//  MoneyGuard
//
//  Created by yury mid on 19.06.2023.
//

import SwiftUI

struct SavingsCardDetailView: View {
    @EnvironmentObject var transactionManager: TransactionManager
    @State var categories: [Category] = []
    
    var body: some View {
        List(categories, id: \.self) { category in
            DisclosureGroup(category.name ?? "") {
                SavingsCategoryView(transactions: transactionManager.filterTransactionsLast30Days().filter{$0.category == category})
            }
        }
        .listStyle(InsetGroupedListStyle())
        .onAppear{
            categories = transactionManager.calculatePotentialSavings()
        }
    }
}

struct SavingsCategoryView: View {
    private let tool = ToolsManager()
    let transactions: [Transaction]
    
    var body: some View {
        VStack {
            ForEach(transactions, content: { transaction in
                NavigationLink(destination: TransactionDetailView(transaction: transaction), label: {
                    VStack{
                        HStack{
                            Image(transaction.category?.icon ?? "default")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 35, height: 35)
                                .padding(.trailing, 5)
                                .padding(.vertical, 5)
                            
                            VStack(alignment: .leading){
                                Text(transaction.account?.name ?? "")
                                    .font(.title3)
                                    .foregroundColor(Color(transaction.category?.color ?? "Blue"))
                                if transaction.comment ?? "" != "" {
                                    Text(transaction.comment ?? "")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .bold()
                                        .lineLimit(3)
                                        .minimumScaleFactor(0.5)
                                }
                                Text(formatDate(transaction.date ?? Date()))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            VStack(alignment: .trailing){
                                Text("\(transaction.category?.type == "expenses" || transaction.category?.type == "transferTo" ? "-" : "+") \(tool.formatCurrency(transaction.value) ?? "")")
                                    .foregroundColor(Color(transaction.category?.type == "expenses" || transaction.category?.type == "transferTo" ? "Red" : "Green"))
                                    .bold()
                                    .font(.title3)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                            }
                        }
                        Divider()
                    }
                })
            })
        }
    }
}



