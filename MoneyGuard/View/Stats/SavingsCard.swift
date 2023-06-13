//
//  SavingsCard.swift
//  MoneyGuard
//
//  Created by yury mid on 14.06.2023.
//

import SwiftUI

struct SavingsCardView: View {
    private let tool: ToolsManager = ToolsManager()
    let spentAmount: Double
    let potentialSavings: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(String(tool.formatCurrency(potentialSavings) ?? ""))
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.green)
                .padding(.bottom, 1)
            
            Text("out of \(tool.formatCurrency(spentAmount) ?? "") spent this month")
                .font(.caption)
                .foregroundColor(.gray)

            
            
            HStack{
                Spacer()
                HStack{
                    Text("btn_open")
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.secondary)
                .font(.caption)
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 2, y: 3)
        .padding(.horizontal)
    }
}
