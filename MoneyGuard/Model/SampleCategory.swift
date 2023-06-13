//
//  SampleCategory.swift
//  MoneyGuard
//
//  Created by yury mid on 14.06.2023.
//

import Foundation

struct SampleCategoryModel: Identifiable {
    let id = UUID()
    let name: String
    let color: String
    let createDate: Date
    let lastActivity: Date
    let icon: String
    let type: String // expenses or replenishments
    let essentialDegree: Int16
}
