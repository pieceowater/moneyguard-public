//
//  SampleGoal.swift
//  MoneyGuard
//
//  Created by yury mid on 14.06.2023.
//

import Foundation

struct SampleGoal: Hashable, Equatable {
    let id = UUID()
    let name: String
    let comment: String
    let deadline: Date
    let sum: Double
    let category: SampleCategoryModel
    let type: String // more or less than sum
    
    static func ==(lhs: SampleGoal, rhs: SampleGoal) -> Bool {
        return lhs.id == rhs.id && lhs.deadline == rhs.deadline
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(deadline)
    }
}
