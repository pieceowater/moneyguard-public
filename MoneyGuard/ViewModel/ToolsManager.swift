//
//  ToolsManager.swift
//  MoneyGuard
//
//  Created by yury mid on 07.06.2023.
//

import Foundation

class ToolsManager {
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    func formatCurrency(_ amount: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.groupingSeparator = " "
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2

        return formatter.string(from: NSNumber(value: amount))
    }
    
}
