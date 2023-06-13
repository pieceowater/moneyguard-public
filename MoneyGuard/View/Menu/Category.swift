//
//  CategoryView.swift
//  MoneyGuard
//
//  Created by yury mid on 07.06.2023.
//

import SwiftUI


struct CategoryView: View {
    let replenishmentCategory: [SampleCategoryModel] = [
        SampleCategoryModel(name: "Salary", color: "Blue", createDate: Date(), lastActivity: Date(), icon: "debt", type: "replenishments", essentialDegree: 1),
        SampleCategoryModel(name: "1xbet", color: "Green", createDate: Date(), lastActivity: Date(), icon: "carebeauty", type: "replenishments", essentialDegree: 2),
        SampleCategoryModel(name: "Investments", color: "Purple", createDate: Date(), lastActivity: Date(), icon: "drugs", type: "replenishments", essentialDegree: 3),
        SampleCategoryModel(name: "Freelance", color: "Teal", createDate: Date(), lastActivity: Date(), icon: "donate", type: "replenishments", essentialDegree: 1)
    ]

    let expensesCategory: [SampleCategoryModel] = [
        SampleCategoryModel(name: "Shopping", color: "Red", createDate: Date(), lastActivity: Date(), icon: "fuel", type: "expenses", essentialDegree: 3),
        SampleCategoryModel(name: "Entertainment", color: "Orange", createDate: Date(), lastActivity: Date(), icon: "gym", type: "expenses", essentialDegree: 2),
        SampleCategoryModel(name: "Dining Out", color: "Yellow", createDate: Date(), lastActivity: Date(), icon: "map", type: "expenses", essentialDegree: 1),
        SampleCategoryModel(name: "Travel", color: "Pink", createDate: Date(), lastActivity: Date(), icon: "help", type: "expenses", essentialDegree: 2),
        SampleCategoryModel(name: "Simping lil asian girls", color: "Red", createDate: Date(), lastActivity: Date(), icon: "fire", type: "expenses", essentialDegree: 3),
        SampleCategoryModel(name: "Gambling", color: "Orange", createDate: Date(), lastActivity: Date(), icon: "dice", type: "expenses", essentialDegree: 1),
        SampleCategoryModel(name: "Utilities", color: "Blue", createDate: Date(), lastActivity: Date(), icon: "funeral", type: "expenses", essentialDegree: 1),
        SampleCategoryModel(name: "Transportation", color: "Green", createDate: Date(), lastActivity: Date(), icon: "gaming", type: "expenses", essentialDegree: 2),
        SampleCategoryModel(name: "Healthcare", color: "Red", createDate: Date(), lastActivity: Date(), icon: "nofood", type: "expenses", essentialDegree: 3),
        SampleCategoryModel(name: "Education", color: "Purple", createDate: Date(), lastActivity: Date(), icon: "education", type: "expenses", essentialDegree: 1),
        SampleCategoryModel(name: "Hobbies", color: "Orange", createDate: Date(), lastActivity: Date(), icon: "guitar", type: "expenses", essentialDegree: 2)
    ]
    
    var body: some View {
            ScrollView {
                VStack(spacing: 16) {
                    CategoryList(title: "Replenishments", categories: replenishmentCategory)
                    CategoryList(title: "Expenses", categories: expensesCategory)
                }
                .padding(16)
            }
        .navigationTitle("Categories")
    }
}

struct CategoryList: View {
    let title: String
    let categories: [SampleCategoryModel]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 8)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible())], spacing: 10) {
                    ForEach(categories.sorted(by: { $0.essentialDegree > $1.essentialDegree }), id: \.name) { category in
                        NavigationLink(destination: Text("Hello")) {
                            CategoryCardView(category: category)
                        }
                    }
                }
            }
        }
    }
}




struct CategoryCardView: View {
    private let tool: ToolsManager = ToolsManager()
    let category: SampleCategoryModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(category.icon)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .aspectRatio(contentMode: .fit)
                
                Text(category.name)
                    .foregroundColor(Color(category.color))
                    .font(.headline)
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.5)
                Spacer()
                StarRatingView(rating: Int(category.essentialDegree))
            }
            
            HStack{
                Text("\(tool.formatDate(category.lastActivity))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(5)
                Spacer()
                
                HStack{
                    Text("btn_open")
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.secondary)
                .font(.caption)
            }
        }
        .padding(15)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        .padding(5)
        
    }
}

struct StarRatingView: View {
    let rating: Int
    
    var body: some View {
        HStack(spacing: 1) {
            ForEach(1...rating, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.caption)
                    .shadow(color: .black.opacity(0.2), radius: 1, x: 1, y: 2)
            }
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView()
    }
}

