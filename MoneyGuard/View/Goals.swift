//
//  GoalsView.swift
//  MoneyGuard
//
//  Created by yury mid on 06.06.2023.
//

import SwiftUI

struct SampleGoal: Hashable, Equatable {
    let id = UUID()
    let name: String
    let comment: String
    let deadline: Date
    let sum: Double
    let category: SampleCategoryModel
    let type: String // more or less than sum
    
    static func ==(lhs: SampleGoal, rhs: SampleGoal) -> Bool {
        return lhs.id == rhs.id && lhs.deadline == rhs.deadline
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(deadline)
    }
}

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
                        Text("Get your goals to make your life better!")
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
                        Text("Add new")
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
