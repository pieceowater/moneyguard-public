//
//  SummaryCard.swift
//  MoneyGuard
//
//  Created by yury mid on 14.06.2023.
//

import SwiftUI

struct SummaryCardView: View {
    private let tool: ToolsManager = ToolsManager()
    let label: String
    let balance: Double
    let color: Color
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            Text(label)
                .font(.headline)
                .padding(.top)
            Text(tool.formatCurrency(balance) ?? "")
                .foregroundColor(color)
                .bold()
            HStack{
                Spacer()
            }
        }
        .padding(.horizontal)
        .background(.ultraThinMaterial)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}
