//
//  CreateGoalView.swift
//  MoneyGuard
//
//  Created by yury mid on 22.06.2023.
//

import SwiftUI

struct CreateGoalView: View {
    @EnvironmentObject var goalsManager: GoalsManager
    @EnvironmentObject var categoriesManager: CategoryManager
    @EnvironmentObject var userSettings: UserSettingsManager
    @Environment(\.presentationMode) var presentationMode
    
    
    @State private var name = ""
    @State private var comment = ""
    @State private var deadline = Date()
    @State private var sum: String = ""
    @State private var selectedType = 1
    private let types = [String(format: NSLocalizedString("goals_tab_more_type", comment: "")), String(format: NSLocalizedString("goals_tab_less_type", comment: ""))]
    
    @State var categories: CategoriesWrapper = CategoriesWrapper(replenishments: [], expenses: [])
    @State var selectedCategory: UUID = UUID()
    
    var body: some View {
        ScrollView{
            Text("goals_tab_add_new")
                .font(.title2)
                .padding(.top)
            VStack{
                TextField("\(NSLocalizedString("word_name", comment: ""))", text: $name)
                    .padding()
                    .padding(.horizontal, 10)
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .padding(.top)
                
                DatePicker("word_deadline", selection: $deadline, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                    .padding()
                
                TextField("word_amount", text: $sum)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    .padding(.horizontal)
                
                Picker(selection: $selectedType, label: Text("tab_mode")) {
                    ForEach(0..<types.count) { index in
                        Text(types[index])
                            .tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.bottom)
                
                
                VStack(alignment: .leading){
                    Text("menu_settings_category_single")
                        .font(.subheadline)
                        .padding(.horizontal)
                    
                    
                    if categories.expenses.count == 0 && categories.replenishments.count == 0 {
                        VStack(alignment: .center, spacing: 25){
                            Image("grass")
                                .resizable()
                                .frame(width: 50, height: 50)
                            Text("placeholder_message_no_categories_alt")
                                .multilineTextAlignment(.center)
                                .font(.caption)
                            HStack{
                                Spacer()
                            }
                        }.padding(.vertical, 20)
                        
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 0) {
                                ForEach(categories.expenses, id: \.self) { category in
                                    Button(action: {
                                        selectedCategory = category.id ?? UUID()
                                        giveHapticFeedback()
                                    }) {
                                        VStack {
                                            Image(category.icon ?? "default")
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                                .padding(.horizontal)
                                                .padding(.top)
                                            Text(category.name ?? "")
                                                .minimumScaleFactor(0.7)
                                                .lineLimit(1)
                                                .padding()
                                        }
                                        .frame(width: 130, height: 130)
                                        .background(.ultraThinMaterial)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(selectedCategory == category.id ? Color.accentColor : Color.clear, lineWidth: 2)
                                        )
                                        .cornerRadius(15)
                                    }
                                }.padding(.horizontal, 10)
                                
                                Divider().padding(.vertical).padding(.horizontal, 10)
                                
                                ForEach(categories.replenishments, id: \.self) { category in
                                    Button(action: {
                                        selectedCategory = category.id ?? UUID()
                                        giveHapticFeedback()
                                    }) {
                                        VStack {
                                            Image(category.icon ?? "default")
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                                .padding(.horizontal)
                                                .padding(.top)
                                            Text(category.name ?? "")
                                                .minimumScaleFactor(0.7)
                                                .lineLimit(1)
                                                .padding()
                                        }
                                        .frame(width: 130, height: 130)
                                        .background(.ultraThinMaterial)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(selectedCategory == category.id ? Color.accentColor : Color.clear, lineWidth: 2)
                                        )
                                        .cornerRadius(15)
                                    }
                                }.padding(.horizontal, 10)
                            }
                        }
                        
                    }
                }
                
                
                VStack(alignment: .leading){ //  note text editor
                    Text("word_comment")
                        .font(.subheadline)
                    TextEditor(text: $comment)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .frame(height: 80)
                }.padding()
                
                
                
                Button {
                    giveHapticFeedback()
                    let sum = Double(sum.replacingOccurrences(of: ",", with: ".")) ?? 0
                    let type = selectedType == 0 ? "more" : "less"
                    
                    
                    if let selectedCategory = categoriesManager.categoryList.first(where: { $0.id == selectedCategory }) {
                        goalsManager.createGoal(goalName: name, goalComment: comment, goalDeadline: deadline, goalSum: sum, goalType: type, goalCategory: selectedCategory)
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                    goalsManager.getGoalList()
                    print(goalsManager.goalsList)
                } label: {
                    HStack{
                        Spacer()
                        Image(systemName: "checkmark")
                        Text("btn_add_new")
                        Spacer()
                    }.padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(15)
                        .padding(.horizontal)
                }
                Button {
                    giveHapticFeedback()
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("btn_hide")
                    .padding()
                }
                
            }
            .onAppear{
                categories.replenishments = categoriesManager.categoryList.filter { $0.type == "replenishments" }.sorted(by: { $0.lastActivity ?? Date() > $1.lastActivity ?? Date() })
                categories.expenses = categoriesManager.categoryList.filter { $0.type == "expenses" }.sorted(by: { $0.lastActivity ?? Date() > $1.lastActivity ?? Date() })
                selectedCategory = categories.expenses.first?.id ?? UUID()
            }
        }
    }
    
}
