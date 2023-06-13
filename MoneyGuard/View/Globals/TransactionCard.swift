//
//  TransactionCard.swift
//  MoneyGuard
//
//  Created by yury mid on 14.06.2023.
//

import SwiftUI

struct TransactionCardView: View {
    private let tool: ToolsManager = ToolsManager()
    @State var transaction: SampleTransaction
    var body: some View {
        HStack{
            Image(transaction.category.icon)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 35, height: 35)
                .padding(5)
            
            VStack(alignment: .leading){
                Text(transaction.category.name)
                    .font(.title3)
                    .foregroundColor(Color(transaction.category.color))
                Text(transaction.account.name)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .bold()
                Text(tool.formatDate(transaction.date))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing){
                Text("\(transaction.category.type == "expenses" ? "-" : "+") \(tool.formatCurrency(transaction.value) ?? "")")
                    .foregroundColor(Color(transaction.category.type == "expenses" ? "Red" : "Green"))
                    .bold()
                    .font(.title3)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 20)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .padding(.horizontal)
    }
}
