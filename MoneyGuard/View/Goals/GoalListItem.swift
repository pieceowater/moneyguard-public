//
//  GoalListItem.swift
//  MoneyGuard
//
//  Created by yury mid on 14.06.2023.
//

import SwiftUI

struct GoalListItemView: View {
    private let tool: ToolsManager = ToolsManager()
    @EnvironmentObject var goalsManager: GoalsManager
    @EnvironmentObject var transactionsManager: TransactionManager
    @State var goal: Goal
    var body: some View {
        VStack{
            Image(goal.category?.icon ?? "default")
                .resizable()
                .frame(width: 180, height: 180)
                .aspectRatio(contentMode: .fill)
                .padding()
            
            VStack(alignment: .leading){
                HStack{
                    VStack(alignment: .leading){
                        Text(goal.name ?? "")
                            .font(.title)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color(goal.category?.color ?? "Blue"))
                            .padding(.horizontal)
                            .padding(.bottom, 5)
                        if !(goal.comment?.isEmpty ?? true) {
                            Text(goal.comment ?? "")
                                .lineLimit(2)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal)
                        }
                    }
                    Spacer()
                    Image(systemName: goalsManager.checkGoalStatus(goal: goal,
                                                                   transactionsByCategory: transactionsManager.getTransactionsByCategory(category: goal.category,
                                                                                                                                         transactions: transactionsManager.transactionsList)
                                                                    .filter({ $0.date ?? Date() <= goal.createDate ?? Date() && $0.date ?? Date() <= goal.deadline ?? Date() })
                                                                  ) ? "checkmark.circle.fill" : "circle"
                    ).font(.title2).padding(.horizontal)
                }

                HStack{
                    Image(systemName: "flag.checkered")
                        .foregroundColor(.secondary)
                        .font(.footnote)
                    Text(tool.formatDate(goal.deadline ?? Date()))
                        .foregroundColor(goal.deadline ?? Date() < Date() ? .red : .secondary )
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
