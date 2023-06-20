//
//  CategoryManager.swift
//  MoneyGuard
//
//  Created by yury mid on 14.06.2023.
//

import Foundation
import SwiftUI

class CategoryManager: ObservableObject {
    private let coreData: CoreDataManager = CoreDataManager.shared
    var categoryList: [Category] = []
    
    var categoryColors: [String: Color] = [:]
    
    init() {
        getCategoriessList()
    }
    
    func getCategoriessList(){
        categoryList = coreData.fetchEntities()
        
        for category in categoryList {
            if let categoryName = category.name {
                if categoryColors[categoryName] == nil {
                    categoryColors[categoryName] = Color(category.color ?? "Blue")
                }
            }
        }
    }
    
    func createCategory(categoryName: String, categoryIcon: String, categoryColor: String, categoryEssentialDegree: Int16, categoryType: String){
        if let newCategory: Category = CoreDataManager.shared.createEntity() {
            newCategory.icon = categoryIcon
            newCategory.name = categoryName
            newCategory.color = categoryColor
            newCategory.createDate = Date()
            newCategory.lastActivity = Date()
            newCategory.essentialDegree = categoryEssentialDegree // 1 - 3
            newCategory.type = categoryType // ("expenses" or "replenishments")
            newCategory.id = UUID()
            
            CoreDataManager.shared.saveContext()
        }
    }
    
    func updateCategory() {
        CoreDataManager.shared.updateEntity()
    }
    
    func deleteCategory(category: Category) {
        CoreDataManager.shared.deleteEntity(entity: category)
    }
}
