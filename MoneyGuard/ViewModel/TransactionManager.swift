//
//  TransactionManager.swift
//  MoneyGuard
//
//  Created by yury mid on 14.06.2023.
//

import Foundation

class TransactionManager: ObservableObject {
    private let coreData: CoreDataManager = CoreDataManager.shared
    var transactionsList: [Transaction] = []
    
    init() {
        getTransactionList()
    }
    
    func getTransactionList(){
        transactionsList = coreData.fetchEntities()
    }
    
    func createTransaction(transactionComment: String, transactionValue: Double, transactionCategory: Category, transactionAccount: Account){
        if let newTransaction: Transaction = CoreDataManager.shared.createEntity() {
            newTransaction.id = UUID()
            newTransaction.date = Date()
            newTransaction.comment = transactionComment
            newTransaction.value = transactionValue
            
            newTransaction.category = transactionCategory
            newTransaction.account = transactionAccount
            
            CoreDataManager.shared.saveContext()
        }
    }
    
    func updateTransaction() {
        CoreDataManager.shared.updateEntity()
    }
    
    func deleteTransaction(transaction: Transaction) {
        CoreDataManager.shared.deleteEntity(entity: transaction)
    }
}
