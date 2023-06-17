//
//  PeriodBtn.swift
//  MoneyGuard
//
//  Created by yury mid on 14.06.2023.
//

import SwiftUI

struct PeriodBtnView: View {
    @Binding var selectedReportPeriod: Int
    let value: Int
    let label: String
    
    var body: some View {
        Button(action: {
            selectedReportPeriod = value
            giveHapticFeedback()
        }) {
            if selectedReportPeriod == value {
                HStack{
                    Spacer()
                    Text(label)
                    Spacer()
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .foregroundColor(.white)
                .background(Color.accentColor)
                .cornerRadius(13)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 2, y: 2)
                
            } else {
                HStack{
                    Spacer()
                    Text(label)
                    Spacer()
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .foregroundColor(.accentColor)
                .background(.ultraThinMaterial)
                .cornerRadius(13)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
            }
                
                
            
        }
        
    }
}
