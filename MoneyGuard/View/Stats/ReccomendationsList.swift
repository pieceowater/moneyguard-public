//
//  ReccomendationsList.swift
//  MoneyGuard
//
//  Created by yury mid on 14.06.2023.
//

import SwiftUI

struct ReccomendationsListView: View {
    var body: some View {
        let recommendations = [
            Recommendation(category: SampleCategoryModel(name: "Smoking", color: "Red", createDate: Date(), lastActivity: Date(), icon: "help", type: "expenses", essentialDegree: 1), message: "Oops! Your expenses are too high for this category."),
            Recommendation(category: SampleCategoryModel(name: "Energy drinks", color: "Blue", createDate: Date(), lastActivity: Date(), icon: "fuel", type: "expenses", essentialDegree: 1), message: "Don't let this category eat up your budget."),
            Recommendation(category: SampleCategoryModel(name: "Snaks", color: "Green", createDate: Date(), lastActivity: Date(), icon: "nofood", type: "expenses", essentialDegree: 1), message: "Save your money for a vacation!"),
        ]
        
        TabView {
            ForEach(recommendations, id: \.self) { recommendation in
                ReccomendationsCardView(recommendation: recommendation)
            }
        }
        .frame(height: 170)
        .tabViewStyle(PageTabViewStyle())
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 2, y: 3)
        .padding(.horizontal)
        
    }
}
