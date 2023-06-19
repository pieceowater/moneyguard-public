//
//  ReccomendationsList.swift
//  MoneyGuard
//
//  Created by yury mid on 14.06.2023.
//

import SwiftUI

struct ReccomendationsListView: View {
    @EnvironmentObject var transactionManager: TransactionManager
    
    @State var recommendations: [Recommendation]
    
    var body: some View {
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
        .onAppear{
             
        }
        
    }
}
