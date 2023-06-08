//
//  HomeView.swift
//  MoneyGuard
//
//  Created by yury mid on 06.06.2023.
//

import SwiftUI

struct SampleTransaction: Hashable, Equatable {
    let id = UUID()
    let date: Date
    let value: Double
    let account: SampleAccountModel
    let category: SampleCategoryModel
    let comment: String = ""
    
    static func ==(lhs: SampleTransaction, rhs: SampleTransaction) -> Bool {
        return lhs.id == rhs.id && lhs.date == rhs.date && lhs.value == rhs.value
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(date)
        hasher.combine(value)
    }
}



struct HomeView: View {
    @EnvironmentObject var userSettings: UserSettingsManager
    @State private var showGallery = false
    private let tool: ToolsManager = ToolsManager()
    let accounts: [SampleAccountModel] = [
        SampleAccountModel(name: "Kaspi Gold", icon: "ball", createDate: Date(), lastActivity: Date(), balance: 1000.0),
        SampleAccountModel(name: "Jusan Bang", icon: "heal", createDate: Date(), lastActivity: Date(), balance: 2500.0),
        SampleAccountModel(name: "Binance", icon: "award", createDate: Date(), lastActivity: Date(), balance: 500.0),
        SampleAccountModel(name: "MetaMask", icon: "love", createDate: Date(), lastActivity: Date(), balance: 1234567891.0)
    ]
    @State private var selectedAccount = -1
    @State private var selectedReportPeriod = 1
    
    @State private var transactions: [SampleTransaction] = [
        SampleTransaction(date: Date(), value: 1000.0, account: SampleAccountModel(name: "Kaspi", icon: "ball", createDate: Date(), lastActivity: Date(), balance: 100000.0), category: SampleCategoryModel(name: "Food", color: "Blue", createDate: Date(), lastActivity: Date(), icon: "pizza", type: "expenses", essentialDegree: 3)),
        SampleTransaction(date: Date(), value: 2000.0, account: SampleAccountModel(name: "Kaspi", icon: "ball", createDate: Date(), lastActivity: Date(), balance: 100000.0), category: SampleCategoryModel(name: "Food", color: "Red", createDate: Date(), lastActivity: Date(), icon: "pizza", type: "expenses", essentialDegree: 3)),
        SampleTransaction(date: Date(), value: 3000.0, account: SampleAccountModel(name: "Kaspi", icon: "ball", createDate: Date(), lastActivity: Date(), balance: 100000.0), category: SampleCategoryModel(name: "Food", color: "Green", createDate: Date(), lastActivity: Date(), icon: "pizza", type: "expenses", essentialDegree: 3)),
        SampleTransaction(date: Date(), value: 4000.0, account: SampleAccountModel(name: "Kaspi", icon: "ball", createDate: Date(), lastActivity: Date(), balance: 100000.0), category: SampleCategoryModel(name: "Food", color: "Blue", createDate: Date(), lastActivity: Date(), icon: "pizza", type: "expenses", essentialDegree: 3)),
        SampleTransaction(date: Date(), value: 5000.0, account: SampleAccountModel(name: "Kaspi", icon: "ball", createDate: Date(), lastActivity: Date(), balance: 100000.0), category: SampleCategoryModel(name: "Food", color: "Red", createDate: Date(), lastActivity: Date(), icon: "pizza", type: "expenses", essentialDegree: 3)),
        SampleTransaction(date: Date(), value: 6000.0, account: SampleAccountModel(name: "Kaspi", icon: "ball", createDate: Date(), lastActivity: Date(), balance: 100000.0), category: SampleCategoryModel(name: "Food", color: "Green", createDate: Date(), lastActivity: Date(), icon: "pizza", type: "expenses", essentialDegree: 3)),
        SampleTransaction(date: Date(), value: 7000.0, account: SampleAccountModel(name: "Kaspi", icon: "ball", createDate: Date(), lastActivity: Date(), balance: 100000.0), category: SampleCategoryModel(name: "Food", color: "Green", createDate: Date(), lastActivity: Date(), icon: "pizza", type: "expenses", essentialDegree: 3)),
        SampleTransaction(date: Date(), value: 8000.0, account: SampleAccountModel(name: "Kaspi", icon: "ball", createDate: Date(), lastActivity: Date(), balance: 100000.0), category: SampleCategoryModel(name: "Food", color: "Green", createDate: Date(), lastActivity: Date(), icon: "pizza", type: "expenses", essentialDegree: 3)),
        SampleTransaction(date: Date(), value: 9000.0, account: SampleAccountModel(name: "Kaspi", icon: "ball", createDate: Date(), lastActivity: Date(), balance: 100000.0), category: SampleCategoryModel(name: "Food", color: "Green", createDate: Date(), lastActivity: Date(), icon: "pizza", type: "expenses", essentialDegree: 3)),
        SampleTransaction(date: Date(), value: 10000.0, account: SampleAccountModel(name: "Kaspi", icon: "ball", createDate: Date(), lastActivity: Date(), balance: 100000.0), category: SampleCategoryModel(name: "Food", color: "Green", createDate: Date(), lastActivity: Date(), icon: "pizza", type: "expenses", essentialDegree: 3)),
        SampleTransaction(date: Date(), value: 11000.0, account: SampleAccountModel(name: "Kaspi", icon: "ball", createDate: Date(), lastActivity: Date(), balance: 100000.0), category: SampleCategoryModel(name: "Food", color: "Green", createDate: Date(), lastActivity: Date(), icon: "pizza", type: "expenses", essentialDegree: 3)),
        SampleTransaction(date: Date(), value: 12000.0, account: SampleAccountModel(name: "Kaspi", icon: "ball", createDate: Date(), lastActivity: Date(), balance: 100000.0), category: SampleCategoryModel(name: "Food", color: "Green", createDate: Date(), lastActivity: Date(), icon: "pizza", type: "expenses", essentialDegree: 3)),
        SampleTransaction(date: Date(), value: 13000.0, account: SampleAccountModel(name: "Kaspi", icon: "ball", createDate: Date(), lastActivity: Date(), balance: 100000.0), category: SampleCategoryModel(name: "Food", color: "Green", createDate: Date(), lastActivity: Date(), icon: "pizza", type: "expenses", essentialDegree: 3))
    ]
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .trailing) {
                    HStack{
                        Image(selectedAccount == -1 ? "default" : accounts[selectedAccount].icon)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .padding(10)
                        
                        Spacer()
                        
                        VStack (alignment: .trailing){
                            Picker(selection: $selectedAccount, label: Text("Account")) {
                                Text("All accounts").tag(-1)
                                ForEach(0..<accounts.count) { index in
                                    Text(accounts[index].name).tag(index)
                                }
                            }
                            Text("\(selectedAccount == -1 ? tool.formatCurrency(accounts.reduce(0, { $0 + $1.balance })) ?? "" : tool.formatCurrency(accounts[selectedAccount].balance) ?? "")")
                                .font(.title2)
                                .fontWeight(.bold)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .foregroundColor(.accentColor)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                .padding(.horizontal)
                .padding(.top)
                
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
            .navigationTitle("MoneyGuard")
//            .navigationTitle("home_tab")
        }
        .overlay(alignment: .trailing) {
            VStack {
                Spacer()
                Button(action: {
                    showGallery = true
                }) {
                    Image(systemName: "plus").foregroundColor(.accentColor)
                        .font(.title)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(100)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 2, y: 2)
                }
                .padding(.trailing, 30)
                .padding(.bottom, 20)
            }
        }
        .sheet(isPresented: $showGallery) {
            GalleryView().accentColor(userSettings.accentColor.color)
        }
    }
}

struct PeriodBtnView: View {
    @Binding var selectedReportPeriod: Int
    let value: Int
    let label: String
    
    var body: some View {
        Button(action: {
            selectedReportPeriod = value
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

struct SummaryCardView: View {
    private let tool: ToolsManager = ToolsManager()
    let label: String
    let balance: Double
    let color: Color
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            Text(label)
                .font(.headline)
                .padding(.top)
            Text(tool.formatCurrency(balance) ?? "")
                .foregroundColor(color)
                .bold()
            HStack{
                Spacer()
            }
        }
        .padding(.horizontal)
        .background(.ultraThinMaterial)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

struct TransactionCardView: View {
    private let tool: ToolsManager = ToolsManager()
    @State var transaction: SampleTransaction
    var body: some View {
        HStack{
            Image(transaction.category.icon)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 35, height: 35)
                .padding(5)
            
            VStack(alignment: .leading){
                Text(transaction.category.name)
                    .font(.title3)
                    .foregroundColor(Color(transaction.category.color))
                Text(transaction.account.name)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .bold()
                Text(tool.formatDate(transaction.date))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing){
                Text("\(transaction.category.type == "expenses" ? "-" : "+") \(tool.formatCurrency(transaction.value) ?? "")")
                    .foregroundColor(Color(transaction.category.type == "expenses" ? "Red" : "Green"))
                    .bold()
                    .font(.title3)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 20)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .padding(.horizontal)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
