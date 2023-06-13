//
//  HomeView.swift
//  MoneyGuard
//
//  Created by yury mid on 06.06.2023.
//

import SwiftUI

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
                
                HomeOverviewSectionView(selectedReportPeriod: $selectedReportPeriod, transactions: $transactions)
                
                
            }
            .navigationTitle("MoneyGuard")
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


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

