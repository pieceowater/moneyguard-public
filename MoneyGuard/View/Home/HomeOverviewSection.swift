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
            Text("home_tab_overview")
                .font(.title2)
                .padding()
            
            HStack {
                PeriodBtnView(selectedReportPeriod: $selectedReportPeriod, value: 1, label: NSLocalizedString("period_filter_daily", comment: ""))
                PeriodBtnView(selectedReportPeriod: $selectedReportPeriod, value: 2, label: NSLocalizedString("period_filter_weekly", comment: ""))
                PeriodBtnView(selectedReportPeriod: $selectedReportPeriod, value: 3, label: NSLocalizedString("period_filter_monthly", comment: ""))
            }
            .padding(.horizontal)
            
            HStack{
                SummaryCardView(label: NSLocalizedString("home_tab_income", comment: ""), balance: 15500.0, color: .green)
                Spacer()
                SummaryCardView(label: NSLocalizedString("home_tab_expense", comment: ""), balance: 210005.0, color: .red)
            }
            .padding()
            
            if transactions.count == 0 {
                HStack{
                    Spacer()
                    VStack{
                        VStack(spacing: 25){
                            Image("help")
                                .resizable()
                                .frame(width: 70, height: 70)
                            Text("placeholder_message_no_transactions")
                                .multilineTextAlignment(.center)
                                
                        }.padding()
                    }
                    Spacer()
                }
                .padding()
            } else {
                LazyVGrid(columns: [GridItem(.flexible())], spacing: 10) {
                    ForEach(transactions.sorted(by: { $0.date > $1.date }).prefix(10), id: \.self) { transaction in
                        NavigationLink(destination: Text("Hello")) {
                            TransactionCardView(transaction: transaction)
                        }
                    }
                    if transactions.count > 10 {
                        NavigationLink(destination: Text("more")) {
                            HStack{
                                Text("btn_show_more")
                                Image(systemName: "arrow.right")
                            }.padding()
                        }
                    }
                    
                    Spacer(minLength: 70)
                }
            }
        }
    }
}
