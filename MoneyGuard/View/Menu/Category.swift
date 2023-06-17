//
//  CategoryView.swift
//  MoneyGuard
//
//  Created by yury mid on 07.06.2023.
//

import SwiftUI

struct CategoriesWrapper {
    var replenishments: [Category]
    var expenses: [Category]
}

struct CategoryView: View {
    @State var categories: CategoriesWrapper = CategoriesWrapper(replenishments: [], expenses: [])
    
    @EnvironmentObject var categoriesManager: CategoryManager
    @EnvironmentObject var userSettings: UserSettingsManager
    @State var showCreateCategroySheet: Bool = false
    
    var body: some View {
            ScrollView {
                VStack(spacing: 16) {
                    CategoryList(title: NSLocalizedString("menu_settings_category_replenishments", comment: ""), categories: categories.replenishments)
                    CategoryList(title: NSLocalizedString("menu_settings_category_expenses", comment: ""), categories: categories.expenses)
                }
                .padding(16)
            }
            .toolbar(content: {
                Button {
                    showCreateCategroySheet = true
                } label: {
                    Text("btn_add_new")
                }
            })
            .sheet(isPresented: $showCreateCategroySheet, content: {
                CreateCatedoryView(categories: $categories)
                    .environmentObject(userSettings)
                    .environmentObject(categoriesManager)
            })
            .onAppear {
                categories.replenishments = categoriesManager.categoryList.filter { $0.type == "replenishments" }
                categories.expenses = categoriesManager.categoryList.filter { $0.type == "expenses" }
            }
            .navigationTitle("menu_settings_category")
    }
}

struct CategoryList: View {
    let title: String
    let categories: [Category]
    
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
    let category: Category
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(category.icon ?? "default")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .aspectRatio(contentMode: .fit)
                
                Text(category.name ?? "")
                    .foregroundColor(Color(category.color ?? "blue"))
                    .font(.headline)
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.5)
                Spacer()
                if category.type == "expenses" {
                    StarRatingView(rating: Int(category.essentialDegree))
                }
            }
            
            HStack{
                Text("\(tool.formatDate(category.lastActivity ?? Date()))")
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

