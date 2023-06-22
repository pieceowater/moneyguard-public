//
//  GoalsView.swift
//  MoneyGuard
//
//  Created by yury mid on 06.06.2023.
//

import SwiftUI

struct GoalsView: View {
    @EnvironmentObject var goalsManager: GoalsManager
    @EnvironmentObject var categoriesManager: CategoryManager
    @EnvironmentObject var userSettings: UserSettingsManager
    
    @State var addGoalIsShowing: Bool = false
    
    var body: some View {
        NavigationView{
            VStack {
                ScrollView {
                    HStack{
                        Text("goals_tab_caprion")
                            .font(.headline)
                        Spacer()
                    }.padding(.horizontal)

                    if (goalsManager.goalsList.sorted(by: { $0.deadline ?? Date() < $1.deadline ?? Date() }).count > 0) {
                        LazyVGrid(columns: [GridItem(.flexible())], spacing: 10) {
                            ForEach(goalsManager.goalsList.sorted(by: { $0.deadline ?? Date() < $1.deadline ?? Date() }), id: \.self) { goal in
                                NavigationLink(destination: GoalDetailView(goal: goal)) {
                                    GoalListItemView(goal: goal)
                                }
                            }
                        }
                    } else {
                        VStack(spacing: 25){
                            Image("award")
                                .resizable()
                                .frame(width: 100, height: 100)
                            Text("placeholder_message_create_goal")
                                .multilineTextAlignment(.center)
                                .font(.headline)
                        }.padding(120)
                    }
                }
            }
            .sheet(isPresented: $addGoalIsShowing) {
                CreateGoalView().accentColor(userSettings.accentColor.color)
            }
            .toolbar {
                Button {
                    addGoalIsShowing = true
                } label: {
                    HStack{
                        Text("btn_add_new")
                            .font(.headline)
                    }
                }

            }
            .navigationTitle("goals_tab")
        }
    }
}

