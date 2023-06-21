//
//  CategoryDetail.swift
//  MoneyGuard
//
//  Created by yury mid on 17.06.2023.
//

import SwiftUI

struct CategoryDetailView: View {
    @EnvironmentObject var userSettings: UserSettingsManager
    @EnvironmentObject var categoriesManager: CategoryManager
    @EnvironmentObject var transactionManager: TransactionManager
    private let tool: ToolsManager = ToolsManager()
    @Environment(\.presentationMode) var presentationMode
    @State private var showGallery = false
    @State private var selectedIcon: Icons? = .default
    @State var editMode = false
    @State private var showAlert = false
    @State var categoryNewName: String = ""
    @State var category: Category
    @State private var selectedDegree: Int = 2
    @State private var selectedColor: CategoryColor = .Blue
    @State private var showNewTransactionSheet = false
    
    @State var transactions: [Transaction] = []
    @State var showLatestFirst: Bool = true
    
    var body: some View {
        ScrollView{
            VStack{
                Image(selectedIcon?.icon ?? "")
                    .resizable()
                    .frame(width: 55, height: 55)
                    .aspectRatio(contentMode: .fill)
                    .padding()
                    .background(.ultraThinMaterial.opacity(editMode ? 1 : 0))
                    .cornerRadius(18)
                    .padding()
                    .onTapGesture {
                        if editMode {
                            showGallery = true
                        }
                    }
                
                if editMode {
                    HStack{
                        Text("word_name")
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    TextField("\(NSLocalizedString("word_name", comment: ""))...", text: $categoryNewName)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    
                    HStack{
                        Text("menu_settings_category_color")
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.horizontal)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(CategoryColor.allCases, id: \.self) { color in
                                Button(action: {
                                    giveHapticFeedback()
                                    selectedColor = color
                                }) {
                                    Circle()
                                        .fill(Color(color.rawValue))
                                        .frame(width: 40, height: 40)
                                        .padding()
                                        .background(.ultraThinMaterial)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(selectedColor == color ? Color.accentColor : Color.clear, lineWidth: 2)
                                                
                                        )
                                        .cornerRadius(20)
                                        
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    
                    if category.type == "expenses" {
                        HStack{
                            VStack(alignment: .leading){
                                Text("menu_settings_category_essential_degree_title")
                                    .font(.headline)
                                Text("menu_settings_category_essential_degree_caption")
                                    .font(.caption)
                            }
                            Spacer()
                            EssentialDegreePicker(selectedDegree: $selectedDegree)
                                .font(.title)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    
                    
                    Button {
                        category.name = categoryNewName
                        category.icon = selectedIcon?.icon
                        category.color = selectedColor.rawValue
                        category.essentialDegree = Int16(selectedDegree)
                        categoriesManager.updateCategory()
                        categoriesManager.getCategoriessList()
                        
                        editMode = false
                        giveHapticFeedback()
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
                        giveHapticFeedback()
                        editMode = false
                        
                        categoryNewName = category.name ?? ""
                        selectedIcon = Icons(rawValue: category.icon ?? "default")
                        selectedColor = CategoryColor(rawValue: category.color ?? "Blue") ?? .Blue
                        selectedDegree = Int(category.essentialDegree)
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
                        showAlert = true
                        giveHapticFeedback()
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
                        Text(category.name ?? "")
                            .font(.title)
                            .foregroundColor(Color(category.color ?? "Blue"))
                        Text("\(tool.formatDate(category.lastActivity ?? Date() ))")
                            .font(.caption)
                        
                        if category.type == "expenses" {
                            StarRatingView(rating: Int(category.essentialDegree))
                        }
                    }
                    .padding(.bottom)
                }
                HStack{
                    Spacer()
                }
            }
            .background(.ultraThinMaterial.opacity(0.5))
            
            if !editMode && transactions.count > 0 {
                VStack(alignment: .center){
                    HStack{
                        Text("stats_tab_transactions")
                            .font(.headline)
                            .padding(.horizontal)
                            .padding(.top)
                        Spacer()
                        Button {
                            showLatestFirst.toggle()
                            transactions = transactionManager.transactionsList
                                .filter { $0.category == category }
                                .sorted(by: { showLatestFirst ? $0.date ?? Date() > $1.date ?? Date() : $0.date ?? Date() < $1.date ?? Date() })
                        } label: {
                            HStack{
                                Image(systemName: showLatestFirst ? "arrow.down" : "arrow.up")
                                    .padding(.horizontal)
                            }
                        }
                        
                    }
                    
                    LazyVGrid(columns: [GridItem(.flexible())], spacing: 10) {
                        ForEach(transactions, id: \.self) { transaction in
                            NavigationLink(destination: TransactionDetailView(transaction: transaction)) {
                                TransactionCardView(transaction: transaction)
                            }
                        }
                        if transactions.count > 40 {
                            NavigationLink(destination: Text("more")) {
                                HStack{
                                    Text("btn_show_more")
                                    Image(systemName: "arrow.right")
                                }.padding()
                            }
                        }
                        
                        Spacer(minLength: 70)
                    }
                }
            }
        }
        .hideKeyboardOnTap(excluding: [AnyView(TextField("\(NSLocalizedString("word_name", comment: ""))...", text: $categoryNewName))])
        .onAppear{
            categoryNewName = category.name ?? ""
            selectedDegree = Int(category.essentialDegree)
            selectedColor = CategoryColor(rawValue: category.color ?? "Blue") ?? .Blue
            selectedIcon = Icons(rawValue: category.icon ?? "default")
            transactions = transactionManager.transactionsList
                .filter { $0.category == category }
                .sorted(by: { showLatestFirst ? $0.date ?? Date() > $1.date ?? Date() : $0.date ?? Date() < $1.date ?? Date() })
        }
        .toolbar {
            Button {
                editMode.toggle()
                giveHapticFeedback()
                categoryNewName = category.name ?? ""
                selectedIcon = Icons(rawValue: category.icon ?? "default")
            } label: {
                if editMode {
                    Text("btn_cancel")
                } else {
                    Text("btn_edit")
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("alert_confirm"),
                message: Text("alert_sure_msg"),
                primaryButton: .destructive(Text("alert_rm_btn"), action: {
                    categoriesManager.deleteCategory(category: category)
                    categoriesManager.getCategoriessList()
                    presentationMode.wrappedValue.dismiss()
                }),
                secondaryButton: .cancel()
            )
        }
        .sheet(isPresented: $showGallery) {
            GalleryView(selectedIcon: $selectedIcon).accentColor(userSettings.accentColor.color)
        }
        .sheet(isPresented: $showNewTransactionSheet, content: {
            NewTransactionView().accentColor(userSettings.accentColor.color)
        })
        .navigationTitle(category.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
}
