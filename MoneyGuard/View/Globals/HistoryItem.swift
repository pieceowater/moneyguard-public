//
//  HistoryItem.swift
//  MoneyGuard
//
//  Created by yury mid on 14.06.2023.
//

import SwiftUI

struct HistoryItemView: View {
    let caption: String
    
    var body: some View {
        HStack{
            Text(caption)
                .font(.headline)
            
            Spacer()
            Image(systemName: "chevron.right")
                .font(.headline)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 2, y: 3)
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}
