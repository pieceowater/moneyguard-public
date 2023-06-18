//
//  AccountDetailView.swift
//  MoneyGuard
//
//  Created by yury mid on 07.06.2023.
//

import SwiftUI

struct AccountDetailView: View {
    @EnvironmentObject var userSettings: UserSettingsManager
    private let tool: ToolsManager = ToolsManager()
    @EnvironmentObject var accountsManager: AccountsManager
//    @State var accounts: [Account]
    @Environment(\.presentationMode) var presentationMode
    @State private var showGallery = false
    @State private var selectedIcon: Icons? = .default
    @State var account: Account
//    @State var account: Int
    @State var editMode = false
    @State private var showAlert = false
    @State var accountNewName: String = ""
    
    var body: some View {
        ScrollView {
            VStack{
                Image(selectedIcon?.icon ?? "")
                    .resizable()
                    .frame(width: 55, height: 55)
                    .aspectRatio(contentMode: .fill)
                    .padding()
                    .background(.ultraThinMaterial.opacity(editMode ? 1 : 0))
                    .cornerRadius(18)
                    .padding()
                    .onTapGesture {
                        if editMode {
                            showGallery = true
                        }
                    }
                
                if editMode {
                    HStack{
                        Text("word_name")
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    TextField("\(NSLocalizedString("word_name", comment: ""))...", text: $accountNewName)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    
                    
                    Button {
                        account.name = accountNewName
                        account.icon = selectedIcon?.icon
                        accountsManager.updateAccount()
                        accountsManager.getAccountsList()
                        editMode = false
                        giveHapticFeedback()
                    } label: {
                        HStack{
                            Spacer()
                            Image(systemName: "checkmark")
                            Text("btn_save")
                            Spacer()
                        }
                        .padding()
                        .font(.headline)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .padding(.horizontal)
                    }
                    
                    Button {
                        giveHapticFeedback()
                        editMode = false
                        accountNewName = account.name ?? ""
                        selectedIcon = Icons(rawValue: account.icon ?? "default")
                    } label: {
                        HStack{
                            Spacer()
                            Image(systemName: "xmark")
                            Text("btn_cancel")
                            Spacer()
                        }
                        .padding()
                        .font(.headline)
                        .background(.ultraThinMaterial)
                        .foregroundColor(.accentColor)
                        .cornerRadius(15)
                        .padding(.horizontal)
                    }
                    
                    Button {
                        showAlert = true
                        giveHapticFeedback()
                    } label: {
                        HStack{
                            Image(systemName: "trash")
                            Text("btn_delete")
                        }
                        .foregroundColor(.red)
                        .padding()
                    }

                } else {
                    VStack(spacing: 10){
                        Text(account.name ?? "")
                            .font(.title)
                        Text("\(tool.formatDate(account.lastActivity ?? Date() ))")
                            .font(.caption)
                        
                        Text("\(tool.formatCurrency(account.balance) ?? "")")
                            .font(.title3)
                            .foregroundColor(.green)
                            .bold()
                            .padding(.bottom)
                    }
                    NavigationLink {
                        TransferView(defaultAccount: account)
                            .environmentObject(accountsManager)
                    } label: {
                        HStack{
                            Text("btn_transfer")
                                .font(.headline)
                            
                            Spacer()
                            Image(systemName: "arrowshape.zigzag.right")
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
                HStack{
                    Spacer()
                }
            }
            .background(.ultraThinMaterial.opacity(0.5))
            
            Spacer()
        }
        .hideKeyboardOnTap(excluding: [AnyView(TextField("\(NSLocalizedString("word_name", comment: ""))...", text: $accountNewName))])
        .onAppear{
            accountNewName = account.name ?? ""
            selectedIcon = Icons(rawValue: account.icon ?? "default")
        }
        .toolbar {
            Button {
                editMode.toggle()
                giveHapticFeedback()
                accountNewName = account.name ?? ""
                selectedIcon = Icons(rawValue: account.icon ?? "default")
            } label: {
                if editMode {
                    Text("btn_cancel")
                } else {
                    Text("btn_edit")
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("alert_confirm"),
                message: Text("alert_sure_msg"),
                primaryButton: .destructive(Text("alert_rm_btn"), action: {
                    accountsManager.deleteAccount(account: account)
                    accountsManager.getAccountsList()
                    presentationMode.wrappedValue.dismiss()
                }),
                secondaryButton: .cancel()
            )
        }
        .sheet(isPresented: $showGallery) {
            GalleryView(selectedIcon: $selectedIcon).accentColor(userSettings.accentColor.color)
        }
        .navigationTitle(account.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
}
