//
//  HomeOverviewSection.swift
//  MoneyGuard
//
//  Created by yury mid on 14.06.2023.
//

import SwiftUI

struct HomeOverviewSectionView: View {
    @Binding var selectedReportPeriod: Int
    @Binding var transactions: [SampleTransaction]
    var body: some View {
        VStack (alignment: .leading){
            Text("Overview")
                .font(.title2)
                .padding()
            
            HStack {
                PeriodBtnView(selectedReportPeriod: $selectedReportPeriod, value: 1, label: "Daily")
                PeriodBtnView(selectedReportPeriod: $selectedReportPeriod, value: 2, label: "Weekly")
                PeriodBtnView(selectedReportPeriod: $selectedReportPeriod, value: 3, label: "Monthly")
            }
            .padding(.horizontal)
            
            HStack{
                SummaryCardView(label: "Income", balance: 15500.0, color: .green)
                Spacer()
                SummaryCardView(label: "Expense", balance: 210005.0, color: .red)
            }
            .padding()
            
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 10) {
                ForEach(transactions.sorted(by: { $0.date > $1.date }).prefix(10), id: \.self) { transaction in
                    NavigationLink(destination: Text("Hello")) {
                        TransactionCardView(transaction: transaction)
                    }
                }
                if transactions.count > 10 {
                    NavigationLink(destination: Text("more")) {
                        HStack{
                            Text("Show more")
                            Image(systemName: "arrow.right")
                        }.padding()
                    }
                }

                Spacer(minLength: 70)
            }
            
        }
    }
}
