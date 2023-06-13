//
//  SampleTransaction.swift
//  MoneyGuard
//
//  Created by yury mid on 14.06.2023.
//

import Foundation

struct SampleTransaction: Hashable, Equatable {
    let id = UUID()
    let date: Date
    let value: Double
    let account: SampleAccountModel
    let category: SampleCategoryModel
    let comment: String = ""
    
    static func ==(lhs: SampleTransaction, rhs: SampleTransaction) -> Bool {
        return lhs.id == rhs.id && lhs.date == rhs.date && lhs.value == rhs.value
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(date)
        hasher.combine(value)
    }
}
