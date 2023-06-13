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
    private let filters: [String] = ["Today", "This month", "All time"]
    
    var body: some View {
        NavigationView{
            ScrollView{
                HStack{
                    Text("Recommendations")
                        .font(.title2)
                    Spacer()
                }.padding()
                
                ReccomendationsView()
                
                HStack{
                    Text("You could save")
                        .font(.title2)
                    Spacer()
                }.padding()
                
                NavigationLink(destination: Text("look behind")) {
                    SavingsCardView(spentAmount: 147450, potentialSavings: 20500)
                }
                
                HStack{
                    Text("History")
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

struct ReccomendationsView: View {
    var body: some View {
        let recommendations = [
            Recommendation(category: SampleCategoryModel(name: "Smoking", color: "Red", createDate: Date(), lastActivity: Date(), icon: "help", type: "expenses", essentialDegree: 1), message: "Oops! Your expenses are too high for this category."),
            Recommendation(category: SampleCategoryModel(name: "Energy drinks", color: "Blue", createDate: Date(), lastActivity: Date(), icon: "fuel", type: "expenses", essentialDegree: 1), message: "Don't let this category eat up your budget."),
            Recommendation(category: SampleCategoryModel(name: "Snaks", color: "Green", createDate: Date(), lastActivity: Date(), icon: "nofood", type: "expenses", essentialDegree: 1), message: "Save your money for a vacation!"),
        ]
        
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
        
    }
}

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
                         print("no")
                        } label: {
                            Text("Hide")
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

struct SavingsCardView: View {
    private let tool: ToolsManager = ToolsManager()
    let spentAmount: Double
    let potentialSavings: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(String(tool.formatCurrency(potentialSavings) ?? ""))
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.green)
                .padding(.bottom, 1)
            
            Text("out of \(tool.formatCurrency(spentAmount) ?? "") spent this month")
                .font(.caption)
                .foregroundColor(.gray)

            
            
            HStack{
                Spacer()
                HStack{
                    Text("btn_open")
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.secondary)
                .font(.caption)
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 2, y: 3)
        .padding(.horizontal)
    }
}

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


struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
