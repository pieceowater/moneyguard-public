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
                                .padding(.bottom)
                        }
                    }
                    NavigationLink {
                        Text("HW")
                    } label: {
                        HStack{
                            Text("menu_settings_category_new_transction")
                                .font(.headline)
                            
                            Spacer()
                            Image(systemName: "creditcard")
                                .font(.headline)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 2, y: 3)
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    }
                }
                HStack{
                    Spacer()
                }
            }
            .background(.ultraThinMaterial.opacity(0.5))
            
            Spacer()
        }
        .onAppear{
            categoryNewName = category.name ?? ""
            selectedDegree = Int(category.essentialDegree)
            selectedColor = CategoryColor(rawValue: category.color ?? "Blue") ?? .Blue
            selectedIcon = Icons(rawValue: category.icon ?? "default")
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
                    categoriesManager.updateCategory()
                    presentationMode.wrappedValue.dismiss()
                }),
                secondaryButton: .cancel()
            )
        }
        .sheet(isPresented: $showGallery) {
            GalleryView(selectedIcon: $selectedIcon).accentColor(userSettings.accentColor.color)
        }
        .navigationTitle(category.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
}