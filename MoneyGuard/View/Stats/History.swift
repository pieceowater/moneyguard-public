//
//  HistoryView.swift
//  MoneyGuard
//
//  Created by yury mid on 20.06.2023.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var transactionManager: TransactionManager
    @EnvironmentObject var categoryManager: CategoryManager
    @EnvironmentObject var accountManager: AccountsManager
    @State var period: Period = Period(startDate: Date(), endDate: Date())
    @State var selectedCategory: Category? = nil
    @State var selectedAccount: Account? = nil
    
    var body: some View {
        ScrollView {
            VStack{
                VStack {
                    VStack(alignment: .leading) {
                        Text("Period")
                            .font(.headline)
                            .padding(.horizontal)
                            .padding(.top)
                        
                        DateRangePicker(startDate: $period.startDate, endDate: $period.endDate)
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
                    
                    HStack{
                        Button(action: {
                            period = Period(startDate: Date(), endDate: Date())
                            selectedCategory = nil
                            selectedAccount = nil
                        }, label: {
                            Text("Reset")
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                        })
                        Spacer()
                        Button(action: {
                            
                        }, label: {
                            Text("Apply")
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        })
                    }
                    
                }
                .padding()
                .background(.ultraThinMaterial)
                .padding(.bottom)
                
                
                Spacer()
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}


struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}


struct DateRangePicker: View {
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    var body: some View {
        HStack{
            DatePicker("", selection: $startDate, in: ...endDate, displayedComponents: .date)
                .datePickerStyle(.compact)
                .padding(.horizontal)
                .onChange(of: startDate) { newStartDate in
                    if newStartDate > endDate {
                        endDate = newStartDate
                    }
                }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.headline)
            Spacer()
            DatePicker("", selection: $endDate, in: startDate..., displayedComponents: .date)
                .datePickerStyle(.compact)
                .labelsHidden()
                .padding(.horizontal)
        }
    }
}
