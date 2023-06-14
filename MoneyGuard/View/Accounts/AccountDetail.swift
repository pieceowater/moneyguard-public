//
//  AccountDetailView.swift
//  MoneyGuard
//
//  Created by yury mid on 07.06.2023.
//

import SwiftUI

struct AccountDetailView: View {
    private let tool: ToolsManager = ToolsManager()
//    let account: SampleAccountModel = SampleAccountModel(name: "Test", icon: "ball", createDate: Date(), lastActivity: Date(), balance: 1234)
    let account: Account
    @State var editMode = false
    
    @State var accountNewName: String = ""
    
    var body: some View {
        ScrollView {
            VStack{
                Image(account.icon ?? "")
                    .resizable()
                    .frame(width: 55, height: 55)
                    .aspectRatio(contentMode: .fill)
                    .padding()
                    .background(.ultraThinMaterial.opacity(editMode ? 1 : 0))
                    .cornerRadius(18)
                    .padding()
                
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
                }
                HStack{
                    Spacer()
                }
            }
            .background(.ultraThinMaterial.opacity(0.5))
            
            
            Spacer()
        }
        .onAppear{
            accountNewName = account.name ?? ""
        }
        .toolbar {
            Button {
                editMode.toggle()
            } label: {
                if editMode {
                    Text("btn_save")
                } else {
                    Text("btn_edit")
                }
            }
        }
        .navigationTitle(account.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//struct AccountDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            AccountDetailView()
//        }
//    }
//}
