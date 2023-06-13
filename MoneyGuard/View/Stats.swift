//
//  StatsView.swift
//  MoneyGuard
//
//  Created by yury mid on 06.06.2023.
//
/*
 
 "We recommend decreasing expenses in this category."
 "Oops! Your expenses are too high for this category."
 "Save your money for a vacation!"
 "Beware of impulse buying in this category."
 "Cut back on unnecessary expenses in this category."
 "Don't let Category 6 eat up your budget."
 "Time to tighten the purse strings for this category."
 "Invest in experiences, not just stuff, in this category."
 "Category 9 is draining your bank account. Take control!"
 "You deserve a treat, but not at the expense of this category."
 "Let's find cheaper alternatives for this category."
 "Watch out! This category is a budget black hole."
 "Keep your spending in check for this category."
 "You can save money by reducing expenses in this category."
 "Your wallet will thank you if you cut back on this category."
 
 */


import SwiftUI

struct StatsView: View {
    private let filters: [String] = [NSLocalizedString("period_filter_today", comment: ""), NSLocalizedString("period_filter_this_month", comment: ""), NSLocalizedString("period_filter_all_time", comment: "")]
    
    var body: some View {
        NavigationView{
            ScrollView{
                HStack{
                    Text("title_stats_tab_recomendation")
                        .font(.title2)
                    Spacer()
                }.padding()
                
                ReccomendationsListView()
                
                HStack{
                    Text("title_stats_tab_wasted_stonks")
                        .font(.title2)
                    Spacer()
                }.padding()
                
                NavigationLink(destination: Text("look behind")) {
                    SavingsCardView(spentAmount: 147450, potentialSavings: 20500)
                }
                
                HStack{
                    Text("title_stats_tab_history")
                        .font(.title2)
                    Spacer()
                }.padding()
                
                ForEach(filters.indices, id: \.self) { index in
                    NavigationLink(destination: Text(String(index))) {
                        HistoryItemView(caption: filters[index])
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
