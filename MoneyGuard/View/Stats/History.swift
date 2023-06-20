//
//  HistoryView.swift
//  MoneyGuard
//
//  Created by yury mid on 20.06.2023.
//

import SwiftUI
import Charts

struct HistoryView: View {
    @EnvironmentObject var transactionManager: TransactionManager
    @EnvironmentObject var categoryManager: CategoryManager
    @EnvironmentObject var accountManager: AccountsManager
    private let tool: ToolsManager = ToolsManager()
    @State var period: Period = Period(startDate: Date(), endDate: Date())
    @State var selectedCategory: Category? = nil
    @State var selectedAccount: Account? = nil
    
    @State var presetPeriod: Int? = 0
    
    @State var transactions: [Transaction] = []
    
    @State var incomeTotal: Double = 0
    @State var expenseTotal: Double = 0
    
    @State var showFilter: Bool = false
    @State var showCharts: Bool = true
    
    var body: some View {
        VStack{
            ScrollView {
                if showFilter {
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text("Period")
                                .font(.headline)
                                .padding(.horizontal)
                                .padding(.top)
                            
                            DateRangePicker(startDate: $period.startDate, endDate: $period.endDate)
                                .padding(.horizontal)
                        }
                        
                        HStack{
                            VStack(alignment: .leading) {
                                Text("Category")
                                    .font(.headline)
                                    .padding(.horizontal)
                                    .padding(.top)
                                
                                Picker("", selection: $selectedCategory) {
                                    Text("All Categories").tag(nil as Category?)
                                    ForEach(categoryManager.categoryList) { category in
                                        Text(category.name ?? "").tag(category as Category?)
                                    }
                                }
                                .pickerStyle(.menu)
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                                .padding(.horizontal)
                                
                                HStack{
                                    Spacer()
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Account")
                                    .font(.headline)
                                    .padding(.horizontal)
                                    .padding(.top)
                                
                                Picker("", selection: $selectedAccount) {
                                    Text("All Accounts").tag(nil as Account?)
                                    ForEach(accountManager.accountList) { account in
                                        Text(account.name ?? "").tag(account as Account?)
                                    }
                                }
                                .pickerStyle(.menu)
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                                .padding(.horizontal)
                                
                                HStack{
                                    Spacer()
                                }
                            }
                        }
                        
                        
                        Divider()
                            .padding(.top)
                        
                        HStack(){
                            
                            
                            
                            Button(action: {
                                updatePeriod()
                                getTransactions()
                                selectedCategory = nil
                                selectedAccount = nil
                                getTransactions()
                            }, label: {
                                Text("Reset")
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 10)
                            })
                            .padding(.horizontal)
                            
                            Spacer()
                            
                            Button(action: {
                                getTransactions()
                            }, label: {
                                Text("Apply")
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 30)
                                    .background(Color.accentColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(13)
                                    .padding(.horizontal)
                            })
                        }
                        .padding(.bottom, 10)
                    }
                    .background(.ultraThinMaterial)
                    .padding(.bottom)
                }
                
                if #available(iOS 16.0, *) {
                    if showCharts && transactions.count != 0 {
                        VStack{
                            Chart {
                                ForEach(transactions.sorted { $0.date ?? Date() < $1.date ?? Date() }.filter { $0.category?.type == "expenses" }) { trans in
                                    BarMark(
                                        x: .value("Date", tool.formatDateMin(trans.date ?? Date())),
                                        y: .value("Amount", trans.value)
                                    )
                                    .foregroundStyle(Color(trans.category?.color ?? "Blue"))
                                }
                            }
                            .onAppear{
                                print(categoryManager.categoryColors)
                            }
                            .chartLegend(.hidden)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(15)
                        }.padding(.horizontal)
                    }
                }
                
                VStack (alignment: .leading){
                    HStack{
                        SummaryCardView(label: NSLocalizedString("home_tab_income", comment: ""), balance: incomeTotal, color: .green)
                        Spacer()
                        SummaryCardView(label: NSLocalizedString("home_tab_expense", comment: ""), balance: expenseTotal, color: .red)
                    }
                    .padding()
                    .onAppear{
                        calculateTotals()
                    }
                    .onChange(of: transactions) { newValue in
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
                            ForEach(transactions, id: \.self) { transaction in
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
                        }
                    }
                    
                    
                    
                }
                
            }
            .navigationTitle("History")
            .onAppear {
                updatePeriod()
                getTransactions()
            }
            .toolbar {
                Button {
                    showFilter.toggle()
                } label: {
                    HStack{
                        Image(systemName: "line.3.horizontal.decrease.circle\(showFilter ? ".fill" : "")")
                            .rotationEffect(Angle(degrees: showFilter ? 0.0 : 180.0))
                    }
                }
                if #available(iOS 16.0, *) {
                    if transactions.count != 0 {
                        Button {
                            showCharts.toggle()
                        } label: {
                            HStack{
                                Image(systemName: "chart.pie\(showCharts ? ".fill" : "")")
                            }
                        }
                    }
                }
                
            }
            
        }
    }
    
    private func calculateTotals() {
        incomeTotal = transactions
            .filter { $0.category?.type == "replenishments" }
            .reduce(0) { $0 + $1.value }
        
        expenseTotal = transactions
            .filter { $0.category?.type == "expenses" }
            .reduce(0) { $0 + $1.value }
    }
    
    private func updatePeriod() {
        switch presetPeriod {
        case 0: // Today
            let currentDate = Date()
            let calendar = Calendar.current
            let startDate = calendar.dateInterval(of: .day, for: currentDate)?.start ?? currentDate
            period = Period(startDate: startDate, endDate: currentDate)
        case 1: // This month
            let currentDate = Date()
            let calendar = Calendar.current
            let startDate = calendar.dateInterval(of: .month, for: currentDate)?.start ?? currentDate
            period = Period(startDate: startDate, endDate: currentDate)
        case 2: // From first transaction date to last transaction date
            let transactions = transactionManager.transactionsList
            let sortedTransactions = transactions.sorted { $0.date ?? Date() < $1.date ?? Date() }
            let startDate = sortedTransactions.first?.date ?? Date()
            let endDate = sortedTransactions.last?.date ?? Date()
            period = Period(startDate: startDate, endDate: endDate)
            showFilter = true
        default:
            break
        }
    }
    
    private func getTransactions() {
        transactions = transactionManager.transactionsList.sorted { $0.date ?? Date() > $1.date ?? Date() }
        transactions = transactionManager.getTransactionsByPeriod(period: period, transactions: transactionManager.getTransactionsByCategory(category: selectedCategory, transactions: transactionManager.getTransactionsByAccount(account: selectedAccount, transactions: transactions)))
    }
    
}

struct DateRangePicker: View {
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    var body: some View {
        HStack(spacing: 10){
            DatePicker("", selection: $startDate, in: ...endDate, displayedComponents: .date)
                .labelsHidden()
                .onChange(of: startDate) { newStartDate in
                    if newStartDate > endDate {
                        endDate = newStartDate
                    }
                }
            Image(systemName: "chevron.right")
                .font(.headline)
            DatePicker("", selection: $endDate, in: startDate..., displayedComponents: .date)
                .labelsHidden()
        }
    }
}
