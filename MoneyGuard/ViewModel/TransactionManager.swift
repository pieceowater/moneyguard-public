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
    
    func createTransaction(transactionDate: Date, transactionComment: String, transactionValue: Double, transactionCategory: Category, transactionAccount: Account){
        if let newTransaction: Transaction = CoreDataManager.shared.createEntity() {
            newTransaction.id = UUID()
            newTransaction.date = transactionDate
            newTransaction.comment = transactionComment
            newTransaction.value = transactionValue
            
            newTransaction.category = transactionCategory
            newTransaction.account = transactionAccount
            
            transactionAccount.balance = transactionCategory.type == "expenses" ? transactionAccount.balance - transactionValue : transactionAccount.balance + transactionValue
            transactionAccount.lastActivity = Date()
            transactionCategory.lastActivity = Date()
            
            CoreDataManager.shared.saveContext()
        }
    }
    
    func updateTransaction() {
        CoreDataManager.shared.updateEntity()
    }
    
    func deleteTransaction(transaction: Transaction) {
        CoreDataManager.shared.deleteEntity(entity: transaction)
    }
    
    func calculatePotentialSavings() -> [Category] {
        let categoriesWithImportanceOne = getCategoriesWithImportanceOne()
        let totalSpendingForImportanceOneAndTwoCategories = getTotalSpendingForImportanceOneAndTwoCategories()
        let threshold = 0.3 // Adjust the threshold as needed

        let last30DaysTransactions = filterTransactionsLast30Days()
        let totalSpendingLast30Days = last30DaysTransactions.reduce(0) { $0 + $1.value }

        var potentialSavingsCategories: [Category] = []

        for category in categoriesWithImportanceOne {
            let categorySpending = getCategorySpending(category: category, transactions: last30DaysTransactions)
            let percentage = categorySpending / totalSpendingLast30Days

            print(percentage)
            if percentage > threshold {
                potentialSavingsCategories.append(category)
            }
        }

        return potentialSavingsCategories
    }
    
    func filterTransactionsLast30Days() -> [Transaction] {
        let currentDate = Date()
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: currentDate)!

        return transactionsList.filter { $0.date ?? Date() >= thirtyDaysAgo }
    }

    
    func getRecommendations() -> [Recommendation] {
        let categories = calculatePotentialSavings()
        var recommendations: [Recommendation] = []
        
        for category in categories {
            let randomPhraseNumber = Int.random(in: 1...15)
            let phraseKey = "template_phrase_\(randomPhraseNumber)"
            let message = NSLocalizedString(phraseKey, comment: "")
            recommendations.append(Recommendation(category: category, message: message))
        }
        
        return recommendations
    }


    private func getCategoriesWithImportanceOne() -> [Category] {
        return CategoryManager().categoryList.filter { $0.essentialDegree == 1 }
    }

    private func getTotalSpendingForImportanceOneAndTwoCategories() -> Double {
        let importanceOneAndTwoCategories = CategoryManager().categoryList.filter { $0.essentialDegree <= 2 }
        let last30DaysTransactions = filterTransactionsLast30Days()
        let totalSpending = importanceOneAndTwoCategories.reduce(0) { $0 + getCategorySpending(category: $1, transactions: last30DaysTransactions) }
        return totalSpending
    }

    private func getCategorySpending(category: Category, transactions: [Transaction]) -> Double {
        let categoryTransactions = transactions.filter { $0.category == category }
        let spending = categoryTransactions.reduce(0) { $0 + $1.value }
        return spending
    }
    
    func getTotalSpendingForCategories() -> Double {
        let totalSpending = calculatePotentialSavings().reduce(0) { $0 + getCategorySpending(category: $1, transactions: filterTransactionsLast30Days()) }
        return totalSpending
    }
    
    func getTotalExpensesLast30Days() -> Double {
        let last30DaysTransactions = filterTransactionsLast30Days()
        let expensesTransactions = last30DaysTransactions.filter { $0.category?.type == "expenses" }
        let totalExpenses = expensesTransactions.reduce(0) { $0 + $1.value }
        return totalExpenses
    }

}
