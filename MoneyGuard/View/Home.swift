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
                    
                    Spacer()
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
