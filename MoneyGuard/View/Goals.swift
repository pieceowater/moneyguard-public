//
//  GoalsView.swift
//  MoneyGuard
//
//  Created by yury mid on 06.06.2023.
//

import SwiftUI

struct GoalsView: View {
    let goals: [SampleGoal] = [
        SampleGoal(name: "Smoke less", comment: "Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum", deadline: Date(), sum: 10000.0, category: SampleCategoryModel(name: "Smoking", color: "Red", createDate: Date(), lastActivity: Date(), icon: "nosmoking", type: "expenses", essentialDegree: 1), type: "less"),
        SampleGoal(name: "Smoke less", comment: "Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum", deadline: Date(), sum: 10000.0, category: SampleCategoryModel(name: "Smoking", color: "Red", createDate: Date(), lastActivity: Date(), icon: "nosmoking", type: "expenses", essentialDegree: 1), type: "less"),
        SampleGoal(name: "Smoke less", comment: "", deadline: Date(), sum: 10000.0, category: SampleCategoryModel(name: "Smoking", color: "Red", createDate: Date(), lastActivity: Date(), icon: "nosmoking", type: "expenses", essentialDegree: 1), type: "less")
    ]
    
    var body: some View {
        NavigationView{
            VStack() {
                ScrollView {
                    HStack{
                        Text("goals_tab_caprion")
                            .font(.headline)
                        Spacer()
                    }.padding(.horizontal)

                    LazyVGrid(columns: [GridItem(.flexible())], spacing: 10) {
                        ForEach(goals.sorted(by: { $0.deadline < $1.deadline }), id: \.self) { goal in
                            NavigationLink(destination: Text("Hello")) {
                                GoalListItemView(goal: goal)
                            }
                        }
                    }
                }
            }
            .toolbar {
                NavigationLink(destination: Text("Hello")) {
                    HStack{
                        Image(systemName: "plus")
                            .font(.subheadline)
                        Text("btn_add_new")
                            .font(.headline)
                    }
                }

            }
            .navigationTitle("goals_tab")
        }
    }
}



struct GoalsView_Previews: PreviewProvider {
    static var previews: some View {
        GoalsView()
    }
}
