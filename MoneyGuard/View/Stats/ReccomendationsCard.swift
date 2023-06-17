//
//  ReccomendationsCard.swift
//  MoneyGuard
//
//  Created by yury mid on 14.06.2023.
//

import SwiftUI

struct Recommendation: Identifiable, Hashable, Equatable {
    let id = UUID()
    let category: SampleCategoryModel
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
                Image(recommendation.category.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 80)
                    .padding(.leading)
                VStack(alignment: .leading){
                    Text("«\(recommendation.message)»")
                        .font(.headline)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                        .padding(.bottom, 5)
                    HStack{
                        Text(recommendation.category.name)
                            .font(.subheadline)
                            .foregroundColor(Color(recommendation.category.color))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        Spacer()
                        Button {
                         
                            giveHapticFeedback()
                        } label: {
                            Text("btn_hide")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                    }
                }
                .padding()
                Spacer()
            }
        }
        .padding()
    }
}
