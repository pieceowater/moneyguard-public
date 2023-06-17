//
//  CreateAccount.swift
//  MoneyGuard
//
//  Created by yury mid on 14.06.2023.
//

import SwiftUI

struct CreateAccountView: View {
    @Binding var accounts: [Account]
    @EnvironmentObject var userSettings: UserSettingsManager
    @EnvironmentObject var accountsManager: AccountsManager 
    @Environment(\.presentationMode) var presentationMode
    @State private var showGallery = false
    
    
    @State var newAccountName: String = ""
    @State private var selectedIcon: Icons? = .default
    @State var newAccountBalance: String = ""
    
    var body: some View {
        VStack{
            ScrollView{
                Text("\(NSLocalizedString("btn_add_new", comment: "")) \(NSLocalizedString("accounts_tab_account", comment: ""))")
                    .font(.title2)
                    .padding(.top)
                
                TextField("\(NSLocalizedString("word_name", comment: ""))...", text: $newAccountName)
                    .padding()
                    .padding(.horizontal, 10)
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    .padding()
                
                Button {
                    giveHapticFeedback()
                    showGallery = true
                } label: {
                    HStack(spacing: 20){
                        Image(selectedIcon?.icon ?? "")
                            .resizable()
                            .frame(width: 45, height: 45)
                        Text("gallery_heading")
                            .font(.headline)
                        Spacer()
                    }.padding(25)
                    .background(.ultraThinMaterial)
                    .cornerRadius(17)
                    .padding()
                }
                
                TextField("\(NSLocalizedString("word_balance", comment: ""))...", text: $newAccountBalance)
                    .padding()
                    .padding(.horizontal, 10)
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    .keyboardType(.decimalPad)
                    .padding()

            }
            
            Spacer()
            Button {
                giveHapticFeedback()
                accountsManager.createAccount(accountName: newAccountName, accountIcon: selectedIcon?.icon ?? "default", accountBalance: Double(newAccountBalance) ?? 0.0)
                accountsManager.getAccountsList()
                accounts = accountsManager.accountList
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack{
                    Spacer()
                    Image(systemName: "checkmark")
                    Text("btn_add_new")
                    Spacer()
                }.padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(15)
                    .padding(.horizontal)
            }
            Button {
                giveHapticFeedback()
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("btn_hide")
                .padding()
            }

        }
        .sheet(isPresented: $showGallery) {
            GalleryView(selectedIcon: $selectedIcon).accentColor(userSettings.accentColor.color)
        }
    }
}
