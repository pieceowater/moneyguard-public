//
//  StatsView.swift
//  MoneyGuard
//
//  Created by yury mid on 06.06.2023.
//


import SwiftUI

struct StatsView: View {
    @EnvironmentObject var transactionManager: TransactionManager
    @EnvironmentObject var categoriesManager: CategoryManager
    private let filters: [String] = [NSLocalizedString("period_filter_today", comment: ""), NSLocalizedString("period_filter_this_month", comment: ""), NSLocalizedString("period_filter_all_time", comment: "")]
    private let tool: ToolsManager = ToolsManager()
    
    var body: some View {
        NavigationView{
            ScrollView{
                
                VStack(spacing: 15){
                    ForEach(categoriesManager.categoryList.filter { $0.expectations > 0 }, id: \.self ) { category in
                        ProgressBarView(icon: category.icon ?? "default", title: category.name ?? "", progress: transactionManager.transactionsList.filter { $0.category == category }.reduce(0) { $0 + $1.value } , maxValue: category.expectations )
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                HStack(spacing: 10){
                    StatsAvgCardView(caption: "stats_tab_daily_avg", value: tool.formatCurrencyMin(transactionManager.calculateAverageSumPerDayForThisMonth()) ?? "--")
                    StatsAvgCardView(caption: "stats_tab_monthly_avg", value: tool.formatCurrencyMin(transactionManager.calculateAverageSumPerMonthForThisYear()) ?? "--")
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
                    StatsNoRecommendationsPlaceholderView()
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

struct StatsAvgCardView: View {
    var caption: String
    @State var value: String
    var body: some View {
        VStack(alignment: .leading){
            Text(NSLocalizedString(caption, comment: ""))
                .font(.subheadline)
            Text(value)
                .font(.headline)
                .foregroundColor(.red)
            HStack{
                Spacer()
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(15)
    }
}

struct StatsNoRecommendationsPlaceholderView: View {
    var body: some View {
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
    }
}

struct ProgressBarView: View {
    private let tool: ToolsManager = ToolsManager()
    let icon: String
    let title: String
    let progress: Double
    let maxValue: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                
                Text(title)
                    .fontWeight(.bold)
                    .font(.title3)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
                    .padding(.top, 8)
                
                Spacer()
                
                if progress >= maxValue {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.accentColor)
                }
            }
            Spacer(minLength: 20)
            ProgressBar(progress: progress, maxValue: maxValue)
                .frame(height: 10)
            
            HStack {
                Text(tool.formatCurrencyMin(progress) ?? "")
                Spacer()
                Text(tool.formatCurrencyMin(maxValue) ?? "")
            }
            .font(.caption)
            
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
    }
}

struct ProgressBar: View {
    let progress: Double
    let maxValue: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color.gray)
                
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color.green)
                    .frame(width: calculateProgressBarWidth(geometry: geometry))
                    .shadow(color: .black.opacity(0.2), radius: 3, x: 2, y: 0)
            }
        }
    }
    
    private func calculateProgressBarWidth(geometry: GeometryProxy) -> CGFloat {
        let width = geometry.size.width
        let progressPercentage = CGFloat(progress / maxValue)
        return progress >= maxValue ? width : width * progressPercentage
    }
}
