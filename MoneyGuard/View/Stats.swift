//
//  StatsView.swift
//  MoneyGuard
//
//  Created by yury mid on 06.06.2023.
//


import SwiftUI

struct StatsView: View {
    @EnvironmentObject var transactionManager: TransactionManager
    private let filters: [String] = [NSLocalizedString("period_filter_today", comment: ""), NSLocalizedString("period_filter_this_month", comment: ""), NSLocalizedString("period_filter_all_time", comment: "")]
    private let tool: ToolsManager = ToolsManager()
    
    var body: some View {
        NavigationView{
            ScrollView{
                
                HStack(spacing: 10){
                    VStack(alignment: .leading){
                        Text("stats_tab_daily_avg")
                            .font(.subheadline)
                        Text(tool.formatCurrencyMin(transactionManager.calculateAverageSumPerDayForThisMonth()) ?? "--")
                            .font(.headline)
                            .foregroundColor(.red)
                        HStack{
                            Spacer()
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    
                    
                    VStack(alignment: .leading){
                        Text("stats_tab_monthly_avg")
                            .font(.subheadline)
                        Text(tool.formatCurrencyMin(transactionManager.calculateAverageSumPerMonthForThisYear()) ?? "--")
                            .font(.headline)
                            .foregroundColor(.red)
                        HStack{
                            Spacer()
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    
                }.padding()
                
                if transactionManager.getRecommendations().count > 0 {
                    HStack{
                        Text("title_stats_tab_recomendation")
                            .font(.title2)
                        Spacer()
                    }.padding(.horizontal)
                        .padding(.bottom)
                    
                    ReccomendationsListView(recommendations: transactionManager.getRecommendations())
                        .environmentObject(transactionManager)
                    
                    
                    HStack{
                        Text("title_stats_tab_wasted_stonks")
                            .font(.title2)
                        Spacer()
                    }.padding()
                    
                    NavigationLink(destination: HistoryView(presetPeriod: 1)) {
                        SavingsCardView(spentAmount: transactionManager.getTotalExpensesLast30Days(), potentialSavings: transactionManager.getTotalSpendingForCategories())
                    }
                } else {
                    VStack(alignment: .leading, spacing: 5){
                        Text("placeholder_message_no_recommendations_heading")
                            .font(.body)
                        Text("placeholder_message_no_recommendations_body")
                            .font(.caption)
                        HStack{
                            Spacer()
                        }
                    }.padding(15)
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                        .padding(.horizontal)
                }
                
                HStack{
                    Text("title_stats_tab_history")
                        .font(.title2)
                    Spacer()
                }.padding()
                
                VStack{
                    ForEach(filters.indices, id: \.self) { index in
                        NavigationLink(destination: HistoryView(presetPeriod: index)) {
                            HistoryItemView(caption: filters[index])
                        }
                    }
                }
                Spacer()
            }
            .refreshable {
                
            }
            .navigationTitle("stats_tab")
        }
    }
}


struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
