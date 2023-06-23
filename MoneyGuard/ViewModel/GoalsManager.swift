//
//  GoalsManager.swift
//  MoneyGuard
//
//  Created by yury mid on 14.06.2023.
//

import Foundation

class GoalsManager: ObservableObject {
    private let coreData: CoreDataManager = CoreDataManager.shared
    @Published var goalsList: [Goal] = [] {
            willSet {
                self.objectWillChange.send()
            }
        }
    
    init() {
        getGoalList()
    }
    
    func getGoalList(){
        goalsList = coreData.fetchEntities()
    }
    
    func createGoal(goalName: String, goalComment: String, goalDeadline: Date, goalSum: Double, goalType: String, goalCategory: Category){
        if let newGoal: Goal = CoreDataManager.shared.createEntity() {
            newGoal.id = UUID()
            newGoal.name = goalName
            newGoal.comment = goalComment
            newGoal.deadline = goalDeadline
            newGoal.sum = goalSum
            newGoal.type = goalType //("more" or "less" than sum)
            newGoal.category = goalCategory
            newGoal.createDate = Date()
            
            CoreDataManager.shared.saveContext()
        }
    }
    
    func updateGoal() {
        CoreDataManager.shared.updateEntity()
    }
    
    func deleteGoal(goal: Goal) {
        CoreDataManager.shared.deleteEntity(entity: goal)
    }
    
    func checkGoalStatus(goal: Goal, transactionsByCategory: [Transaction]) -> Bool {
        print(goal)
        print(transactionsByCategory)
        let currentDate = Date()
        print(transactionsByCategory.reduce(0) { $0 + $1.value })
        if goal.type == "less" {
            return goal.sum >= transactionsByCategory.reduce(0) { $0 + $1.value } && goal.deadline ?? Date() < currentDate // OK less
        } else if goal.type == "more" {
            return goal.sum <= transactionsByCategory.reduce(0) { $0 + $1.value } && goal.deadline ?? Date() < currentDate // OK more
        } else {
            return false
        }
        
        /*
         выполнил в срок меньше суммы = сумма больше чем транзакции И дэдлайн больше текущего времени
         выполнил в срок больше суммы = сумма меньше чем транзакции И дэдлайн больше текущего времени
         */
    }
    
}
