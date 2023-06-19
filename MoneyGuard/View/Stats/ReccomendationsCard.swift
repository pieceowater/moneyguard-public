//
//  ReccomendationsCard.swift
//  MoneyGuard
//
//  Created by yury mid on 14.06.2023.
//

import SwiftUI

struct Recommendation: Identifiable, Hashable, Equatable {
    let id = UUID()
    let category: Category
    let message: String
    
    static func ==(lhs: Recommendation, rhs: Recommendation) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct ReccomendationsCardView: View {
    let recommendation: Recommendation
    
    var body: some View {
        VStack {
            HStack{
                Image(recommendation.category.icon ?? "default")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 70)
                    .padding(.leading)
                VStack(alignment: .leading){
                    Text("«\(recommendation.message)»")
                        .font(.headline)
                        .lineLimit(3)
                        .minimumScaleFactor(0.5)
                        .padding(.bottom, 5)
                    HStack{
                        Text(recommendation.category.name ?? "")
                            .font(.subheadline)
                            .foregroundColor(Color(recommendation.category.color ?? "Blue"))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        Spacer()
                    }
                }
                .padding()
                Spacer()
            }
        }
        .padding()
    }
}
