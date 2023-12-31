//
//  AccountsManager.swift
//  MoneyGuard
//
//  Created by yury mid on 14.06.2023.
//

import Foundation

class AccountsManager: ObservableObject {
    private let coreData: CoreDataManager = CoreDataManager.shared
//    var accountList: [Account] = []
    @Published var accountList: [Account] = [] {
        willSet {
            self.objectWillChange.send()
        }
    }
    
    init() {
        getAccountsList()
    }
    
    func getAccountsList(){
        accountList = coreData.fetchEntities()
    }
    
    func createAccount(accountName: String, accountIcon: String, accountBalance: Double){
        if let newAccount: Account = CoreDataManager.shared.createEntity() {
            newAccount.balance = accountBalance
            newAccount.icon = accountIcon
            newAccount.name = accountName
            newAccount.createDate = Date()
            newAccount.lastActivity = Date()
            newAccount.id = UUID()
            
            CoreDataManager.shared.saveContext()
            
            UserSettingsManager.shared.selectedAccountID = newAccount.id
            UserSettingsManager.shared.saveSelectedAccount()
        }
    }
    
    func updateAccount() {
        CoreDataManager.shared.updateEntity()
    }
    
    func deleteAccount(account: Account) {
        CoreDataManager.shared.deleteEntity(entity: account)
    }
    
}
