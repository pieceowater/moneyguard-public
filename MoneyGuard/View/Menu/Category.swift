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
    @EnvironmentObject var categoriesManager: CategoryManager
    @EnvironmentObject var userSettings: UserSettingsManager
    @State var showCreateCategroySheet: Bool = false
    
    var body: some View {
            ScrollView {
                VStack(spacing: 16) {
                    if categoriesManager.categoryList.filter({ $0.type == "expenses" }).sorted(by: { $0.essentialDegree > $1.essentialDegree }).count == 0 && categoriesManager.categoryList.filter({ $0.type == "replenishments" }).sorted(by: { $0.essentialDegree > $1.essentialDegree }).count == 0 {
                        VStack(spacing: 25){
                            Image("grass")
                                .resizable()
                                .frame(width: 150, height: 150)
                            Text("placeholder_message_no_category")
                                .multilineTextAlignment(.center)
                                .font(.headline)
                            
                        }.padding(.vertical, 100)
                    } else {
                        if categoriesManager.categoryList.filter({ $0.type == "replenishments" }).sorted(by: { $0.essentialDegree > $1.essentialDegree }).count == 0 {
                            VStack(spacing: 25){
                                Image("debt")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                Text("placeholder_message_no_replenishments")
                                    .multilineTextAlignment(.center)
                                    .font(.headline)
                                
                            }.padding(.vertical, 50)
                        } else {
                            CategoryList(title: NSLocalizedString("menu_settings_category_replenishments", comment: ""), type: "replenishments")
                        }
                        
                        if categoriesManager.categoryList.filter({ $0.type == "expenses" }).sorted(by: { $0.essentialDegree > $1.essentialDegree }).count == 0 {
                            VStack(spacing: 25){
                                Image("donate")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                Text("placeholder_message_no_expenses")
                                    .multilineTextAlignment(.center)
                                    .font(.headline)
                                
                            }.padding(.vertical, 50)
                        } else {
                            CategoryList(title: NSLocalizedString("menu_settings_category_expenses", comment: ""), type: "expenses")
                        }
                    }
                    
                }
                .padding(16)
            }
            .toolbar(content: {
                Button {
                    giveHapticFeedback()
                    showCreateCategroySheet = true
                } label: {
                    Text("btn_add_new")
                }
            })
            .sheet(isPresented: $showCreateCategroySheet, content: {
                CreateCatedoryView().accentColor(userSettings.accentColor.color)
                    .environmentObject(userSettings)
                    .environmentObject(categoriesManager)
            })
            .navigationTitle("menu_settings_category")
    }
}

struct CategoryList: View {
    @EnvironmentObject var categoriesManager: CategoryManager
    let title: String
    @State var type: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 8)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible())], spacing: 10) {
                    ForEach(categoriesManager.categoryList.filter { $0.type == type }.sorted(by: { $0.essentialDegree > $1.essentialDegree }), id: \.self) { category in
                        NavigationLink(destination: CategoryDetailView(category: category).environmentObject(categoriesManager)) {
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
    @State var category: Category
    
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

