//
//  TransactionCard.swift
//  MoneyGuard
//
//  Created by yury mid on 14.06.2023.
//

import SwiftUI

struct TransactionCardView: View {
    private let tool: ToolsManager = ToolsManager()
    @State var transaction: Transaction
    var body: some View {
        HStack{
            Image(transaction.category?.icon ?? "default")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 35, height: 35)
                .padding(5)
            
            VStack(alignment: .leading){
                Text(transaction.category?.name ?? "")
                    .font(.title3)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color(transaction.category?.color ?? "Blue"))
                Text(transaction.account?.name ?? "")
                    .font(.caption)
                    .bold()
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.secondary)
                Text(formatDate(transaction.date ?? Date()))
                    .font(.caption)
                    .multilineTextAlignment(.leading)
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
        .padding(.vertical, 15)
        .padding(.horizontal, 20)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .padding(.horizontal)
    }
    
    
}

func formatDate(_ date: Date?) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm, dd/MM"
    return formatter.string(from: date ?? Date())
}
