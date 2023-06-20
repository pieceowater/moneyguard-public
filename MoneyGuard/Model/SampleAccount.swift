//
//  SampleAccountModel.swift
//  MoneyGuard
//
//  Created by yury mid on 14.06.2023.
//

import Foundation

struct SampleAccountModel: Identifiable {
    let id: UUID = UUID()
    let name: String
    let icon: String
    let createDate: Date
    let lastActivity: Date
    let balance: Double
}
