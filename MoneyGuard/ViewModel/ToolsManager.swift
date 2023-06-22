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
    
    func formatDateMin(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter.string(from: date )
    }
    
    func formatCurrencyMin(_ amount: Double) -> String? {
        let number = NSNumber(value: amount)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.groupingSeparator = " "
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1
        
        if amount >= 1_000_000 {
            let millionsValue = amount / 1_000_000
            return (formatter.string(from: NSNumber(value: millionsValue))?.replacingOccurrences(of: ".0", with: "") ?? "") + "M"
        } else if amount >= 1_000 {
            let thousandsValue = amount / 1_000
            return (formatter.string(from: NSNumber(value: thousandsValue))?.replacingOccurrences(of: ".0", with: "") ?? "") + "K"
        } else {
            return formatter.string(from: number)
        }
    }


    
}
