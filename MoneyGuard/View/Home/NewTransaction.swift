//
//  NewTransaction.swift
//  MoneyGuard
//
//  Created by yury mid on 17.06.2023.
//

import SwiftUI

struct NewTransactionView: View {
    @EnvironmentObject var userSettings: UserSettingsManager
    @EnvironmentObject var accountManager: AccountsManager
    @EnvironmentObject var categoriesManager: CategoryManager
    
    private let tool: ToolsManager = ToolsManager()
    @Environment(\.presentationMode) var presentationMode
    
    @State private var amount: String = ""
    @State private var amountPreCalculation: Double = 0.0
    @FocusState private var isTextFieldFocused: Bool
    
    @State private var comment: String = ""
    
    @State private var showDatepicker = false
    @State private var selectedDateCode = 0
    @State private var selectedDate = Date()
    
    @State var accounts: [Account] = []
    @State var categories: CategoriesWrapper = CategoriesWrapper(replenishments: [], expenses: [])
    @State var selectedCategory: UUID = UUID()
    
    var body: some View {
        VStack{
            
            Rectangle()
                .frame(width: 100, height: 5)
                .foregroundColor(Color.gray)
                .cornerRadius(5)
                .shadow(radius: 3)
                .padding(.top, 15)
                .padding(.bottom, 10)
            
            ScrollView {
                
                HStack{
                    Text("New Transaction")
                        .font(.title2)
                    Spacer()
                }.padding(.horizontal)
                
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .focused($isTextFieldFocused)
                
                /*
                 .onChange(of: amount) { newValue in
                     if newValue != "" {
                         amountPreCalculation = calculateExpression(newValue) ?? 0
                     }
                 }
                 
                HStack(spacing: 5){ // custom key
                    Button(action: {amount+="+"}, label: {Text("+").padding(.horizontal, 39).padding(.vertical, 5).background(.ultraThinMaterial).cornerRadius(10)})
                    Button(action: {amount+="-"}, label: {Text("-").padding(.horizontal, 39).padding(.vertical, 5).background(.ultraThinMaterial).cornerRadius(10)})
                    Button(action: {amount+="*"}, label: {Text("*").padding(.horizontal, 39).padding(.vertical, 5).background(.ultraThinMaterial).cornerRadius(10)})
                    Button(action: {amount+="/"}, label: {Text("/").padding(.horizontal, 39).padding(.vertical, 5).background(.ultraThinMaterial).cornerRadius(10)})
                }
                
                
                HStack{
                    Spacer()
                    Text(tool.formatCurrency(amountPreCalculation) ?? "")
                        .padding(.horizontal)
                }
                 */
                
                Divider().padding()
                
                VStack(alignment: .leading){
                    Text("Category")
                        .font(.subheadline)
                        .padding(.horizontal)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(categories.expenses, id: \.self) { category in
                                Button(action: {
                                    selectedCategory = category.id ?? UUID()
                                    giveHapticFeedback()
                                }) {
                                    VStack {
                                        Image(category.icon ?? "default")
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .padding(.horizontal)
                                            .padding(.top)
                                        Text(category.name ?? "")
                                            .minimumScaleFactor(0.7)
                                            .lineLimit(1)
                                            .padding()
                                    }
                                    .frame(width: 130, height: 130)
                                    .background(.ultraThinMaterial)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(selectedCategory == category.id ? Color.accentColor : Color.clear, lineWidth: 2)
                                    )
                                    .cornerRadius(15)
                                }
                            }
                            
                            Divider().padding(.vertical)
                            
                            ForEach(categories.replenishments, id: \.self) { category in
                                Button(action: {
                                    selectedCategory = category.id ?? UUID()
                                    giveHapticFeedback()
                                }) {
                                    VStack {
                                        Image(category.icon ?? "default")
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .padding(.horizontal)
                                            .padding(.top)
                                        Text(category.name ?? "")
                                            .minimumScaleFactor(0.7)
                                            .lineLimit(1)
                                            .padding()
                                    }
                                    .frame(width: 130, height: 130)
                                    .background(.ultraThinMaterial)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(selectedCategory == category.id ? Color.accentColor : Color.clear, lineWidth: 2)
                                    )
                                    .cornerRadius(15)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }

            
                
                VStack(alignment: .leading){ // date picker
                    Text("Date")
                        .font(.subheadline)
                        .padding(.horizontal)
                    HStack {
                        DatePresetBtnView(dateCode: $selectedDateCode, value: 0, label: NSLocalizedString("Today", comment: ""))
                        DatePresetBtnView(dateCode: $selectedDateCode, value: -1, label: NSLocalizedString("Yesterday", comment: ""))
                        DatePresetBtnView(dateCode: $selectedDateCode, value: 2, label: NSLocalizedString("Custom", comment: ""))
                    }
                    .padding(.horizontal)
                    .onChange(of: selectedDateCode) { newValue in
                        selectedDate = Date()
                        if selectedDateCode == newValue && newValue == -1 {
                            selectedDate = Calendar.current.date(byAdding: .day, value: newValue, to: selectedDate) ?? selectedDate
                        }
                        showDatepicker = selectedDateCode == 2 ? true : false
                    }
                    if showDatepicker {
                        DatePicker("Custom date", selection: $selectedDate, in: ...Date(), displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.graphical)
                            .labelsHidden()
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(15)
                            .padding(.horizontal)
                            .padding(.bottom, 5)
                    }
                }.padding(.top)
                
                VStack(alignment: .leading){
                    Text("Account")
                        .font(.subheadline)
                        .padding(.horizontal)
                    VStack(alignment: .trailing) {
                        HStack{
                            if let selectedUUID = userSettings.selectedAccountID {
                                if let account = accounts.first(where: { $0.id == selectedUUID }) {
                                    Image(account.icon ?? "default")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 40, height: 40)
                                        .padding(10)
                                    
                                } else {
                                    Image("default")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 40, height: 40)
                                        .padding(10)
                                }
                            } else {
                                Image("default")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .padding(10)
                            }
                            
                            Spacer()
                            
                            VStack (alignment: .trailing){
                                
                                Picker(selection: $userSettings.selectedAccountID, label: Text("accounts_tab_account")) {
                                    Text("accounts_tab_all_accounts").tag(nil as UUID?)
                                    ForEach(accounts.sorted(by: { $0.lastActivity ?? Date() > $1.lastActivity ?? Date() }), id: \.id) { account in
                                        Text(account.name ?? "")
                                            .tag(account.id)
                                    }
                                }
                                .onChange(of: userSettings.selectedAccountID) { newSelectedAccountID in
                                    userSettings.saveSelectedAccount()
                                }
                                
                                
                                if let selectedUUID = userSettings.selectedAccountID {
                                    if let account = accounts.first(where: { $0.id == selectedUUID }) {
                                        Text("\(tool.formatCurrency(Double(account.balance)) ?? "")")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                            .foregroundColor(.accentColor)
                                            .padding(.horizontal)
                                    } else {
                                        let totalBalance = accounts.reduce(0) { $0 + ($1.balance ) }
                                        Text("\(tool.formatCurrency(Double(totalBalance)) ?? "")")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                            .foregroundColor(.accentColor)
                                            .padding(.horizontal)
                                    }
                                } else {
                                    let totalBalance = accounts.reduce(0) { $0 + ($1.balance ) }
                                    Text("\(tool.formatCurrency(Double(totalBalance)) ?? "")")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                        .foregroundColor(.accentColor)
                                        .padding(.horizontal)
                                }
                                
                                
                                
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .padding(.horizontal)
                    
                }.padding(.top)
                
                Divider().padding()
                
                VStack(alignment: .leading){ //  note text editor
                    Text("Transaction comment")
                        .font(.subheadline)
                    TextEditor(text: $comment)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .frame(height: 80)
                }.padding(.horizontal)
                    .padding(.bottom)
                
                
                
            }
            
            Button {
                giveHapticFeedback()
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack{
                    Spacer()
                    Text("btn_add_new")
                    Spacer()
                }.padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .padding(.bottom, 5)
            }
            
        }
        .onAppear{
            accounts = accountManager.accountList
            categories.replenishments = categoriesManager.categoryList.filter { $0.type == "replenishments" }.sorted(by: { $0.lastActivity ?? Date() > $1.lastActivity ?? Date() })
            categories.expenses = categoriesManager.categoryList.filter { $0.type == "expenses" }.sorted(by: { $0.lastActivity ?? Date() > $1.lastActivity ?? Date() })
            selectedCategory = categories.expenses.first?.id ?? UUID()
            isTextFieldFocused = true
        }
        .hideKeyboardOnTap(excluding: [AnyView(TextField("Amount", text: $amount))])
    }
    
    

}


struct NewTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        NewTransactionView()
    }
}

struct DatePresetBtnView: View {
    @Binding var dateCode: Int
    let value: Int
    let label: String
    
    var body: some View {
        Button(action: {
            dateCode = value
            giveHapticFeedback()
        }) {
            if dateCode == value {
                HStack{
                    Spacer()
                    Text(label)
                    Spacer()
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                .foregroundColor(.white)
                .background(Color.accentColor)
                .cornerRadius(13)
                
            } else {
                HStack{
                    Spacer()
                    Text(label)
                    Spacer()
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                .foregroundColor(.accentColor)
                .background(.ultraThinMaterial)
                .cornerRadius(13)
            }
        }
    }
}
