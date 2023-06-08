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
                                GoalView(goal: goal)
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

struct GoalView: View {
    private let tool: ToolsManager = ToolsManager()
    @State var goal: SampleGoal
    var body: some View {
        VStack{
            Image(goal.category.icon)
                .resizable()
                .frame(width: 180, height: 180)
                .aspectRatio(contentMode: .fill)
                .padding()
            
            VStack(alignment: .leading){
                Text(goal.name)
                    .font(.title)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(Color(goal.category.color))
                    .padding(.horizontal)
                    .padding(.bottom, 5)
                if !goal.comment.isEmpty {
                    Text(goal.comment)
                        .lineLimit(2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                }

                HStack{
                    Image(systemName: "flag.checkered")
                        .foregroundColor(.secondary)
                        .font(.footnote)
                    Text(tool.formatDate(goal.deadline))
                        .foregroundColor(.secondary)
                        .font(.footnote)
                    Spacer()
                    Text("btn_open")
                    Image(systemName: "arrow.right")
                }
                .padding(.horizontal)
                .padding(.top, 10)

            }
            .padding(.vertical)
            .padding(.horizontal, 5)
            .background(.ultraThinMaterial)
            .shadow(color: .black.opacity(0.1), radius: 7, x: 0, y: -2)
            
        }
        .background(.ultraThinMaterial)
        .cornerRadius(25)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 2, y: 3)
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
        
}

struct GoalsView_Previews: PreviewProvider {
    static var previews: some View {
        GoalsView()
    }
}
