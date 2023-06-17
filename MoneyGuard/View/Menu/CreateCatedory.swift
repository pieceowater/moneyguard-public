//
//  CreateCatedory.swift
//  MoneyGuard
//
//  Created by yury mid on 17.06.2023.
//

import SwiftUI

struct CreateCatedoryView: View {
    @Binding var categories: CategoriesWrapper
    
    @EnvironmentObject var categoriesManager: CategoryManager
    @EnvironmentObject var userSettings: UserSettingsManager
    @Environment(\.presentationMode) var presentationMode
    
    @State var newCategoryName = ""
    
    @State private var showGallery = false
    @State private var selectedIcon: Icons? = .default
    
    @State private var selectedColor: CategoryColor = .Blue
    
    @State private var selectedType = 1
    private let types = [String(format: NSLocalizedString("menu_settings_category_replenishments", comment: "")), String(format: NSLocalizedString("menu_settings_category_expenses", comment: ""))]
    
    @State private var selectedDegree: Int = 2
        
    var body: some View {
        ScrollView{
            Text("menu_settings_category_add_new")
                .font(.title2)
                .padding(.top)
            VStack{
                TextField("\(NSLocalizedString("word_name", comment: ""))...", text: $newCategoryName)
                    .padding()
                    .padding(.horizontal, 10)
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    .padding()
                
                Picker(selection: $selectedType, label: Text("tab_mode")) {
                    ForEach(0..<types.count) { index in
                        Text(types[index])
                            .tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                Button {
                    giveHapticFeedback()
                    showGallery = true
                } label: {
                    HStack(spacing: 20){
                        Image(selectedIcon?.icon ?? "")
                            .resizable()
                            .frame(width: 45, height: 45)
                        Text("gallery_heading")
                            .font(.headline)
                        Spacer()
                    }.padding(25)
                    .background(.ultraThinMaterial)
                    .cornerRadius(17)
                    .padding()
                }
                
                
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
                
                if selectedType == 1 {
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
                    giveHapticFeedback()
                    let newCategoryType = selectedType == 0 ? "replenishments" : "expenses"
                    categoriesManager.createCategory(categoryName: newCategoryName, categoryIcon: selectedIcon?.icon ?? "default", categoryColor: selectedColor.rawValue, categoryEssentialDegree: Int16(selectedDegree), categoryType: newCategoryType)
                    categoriesManager.getCategoriessList()
                    categories.replenishments = categoriesManager.categoryList.filter { $0.type == "replenishments" }
                    categories.expenses = categoriesManager.categoryList.filter { $0.type == "expenses" }
                    
                    presentationMode.wrappedValue.dismiss()
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
        }
        .sheet(isPresented: $showGallery) {
            GalleryView(selectedIcon: $selectedIcon).accentColor(userSettings.accentColor.color)
        }
    }
}

struct EssentialDegreePicker: View {
    @Binding var selectedDegree: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...3, id: \.self) { degree in
                Button(action: {
                    giveHapticFeedback()
                    selectedDegree = degree
                }) {
                    Image(systemName: degree <= selectedDegree ? "star.fill" : "star")
                        .foregroundColor(degree <= selectedDegree ? .yellow : .gray)
                        .shadow(color: .black.opacity(0.1), radius: 1, x: 1, y: 2)
                }
            }
        }
    }
}


//struct CreateCatedoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateCatedoryView()
//    }
//}
