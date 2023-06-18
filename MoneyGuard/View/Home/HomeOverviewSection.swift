//
//  HomeOverviewSection.swift
//  MoneyGuard
//
//  Created by yury mid on 14.06.2023.
//

import SwiftUI

struct HomeOverviewSectionView: View {
    @Binding var selectedReportPeriod: Int
    @Binding var transactions: [Transaction]
    
    @State var incomeTotal: Double = 0
    @State var expenseTotal: Double = 0
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
            .onChange(of: selectedReportPeriod) { newValue in
                calculateTotals()
            }
            
            HStack{
                SummaryCardView(label: NSLocalizedString("home_tab_income", comment: ""), balance: incomeTotal, color: .green)
                Spacer()
                SummaryCardView(label: NSLocalizedString("home_tab_expense", comment: ""), balance: expenseTotal, color: .red)
            }
            .padding()
            .onAppear{
                calculateTotals()
            }
            .onChange(of: filteredTransactions) { newValue in
                calculateTotals()
            }
            
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
                    ForEach(filteredTransactions, id: \.self) { transaction in
                        NavigationLink(destination: TransactionDetailView(transaction: transaction)) {
                            TransactionCardView(transaction: transaction)
                        }
                    }
                    if transactions.count > 40 {
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
    
    private var filteredTransactions: [Transaction] {
            let currentDate = Date()
            
            switch selectedReportPeriod {
            case 1: // Daily
                return transactions.filter {
                    Calendar.current.isDateInToday($0.date ?? Date())
                }
            case 2: // Weekly
                return transactions.filter {
                    Calendar.current.isDate($0.date ?? Date(), equalTo: currentDate, toGranularity: .weekOfYear)
                }
            case 3: // Monthly
                return transactions.filter {
                    Calendar.current.isDate($0.date ?? Date(), equalTo: currentDate, toGranularity: .month)
                }
            default:
                return transactions
            }
        }
    
    private func calculateTotals() {
        incomeTotal = filteredTransactions
            .filter { $0.category?.type == "replenishments" }
            .reduce(0) { $0 + $1.value }
        
        expenseTotal = filteredTransactions
            .filter { $0.category?.type == "expenses" }
            .reduce(0) { $0 + $1.value }
    }
    
}
