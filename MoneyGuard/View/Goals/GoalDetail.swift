//
//  GoalDetailView.swift
//  MoneyGuard
//
//  Created by yury mid on 22.06.2023.
//

import SwiftUI

struct GoalDetailView: View {
    @State var goal: Goal
    @EnvironmentObject var goalsManager: GoalsManager
    @EnvironmentObject var categoriesManager: CategoryManager
    @EnvironmentObject var transactionManager: TransactionManager
    @EnvironmentObject var userSettings: UserSettingsManager
    private let tool: ToolsManager = ToolsManager()
    @Environment(\.presentationMode) var presentationMode
    
    @State var editMode = false
    @State private var showAlert = false
    @State var goalNewName: String = ""
    @State var goalNewComment: String = ""
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                if !editMode {
                HStack {
                    VStack (alignment: .leading){
                        Text("word_deadline")
                            .font(.caption2)
                        Text(tool.formatDate(goal.deadline ?? Date()))
                            .font(.caption)
                            .foregroundColor(goal.deadline ?? Date() < Date() ? .red : .secondary )
                    }
                    Spacer()
                }.padding(.horizontal)
                
                HStack{
                    Image(goal.category?.icon ?? "default")
                        .resizable()
                        .frame(width: 50, height: 50)
                    
                    VStack (alignment: .leading, spacing: 10){
                        Text(goal.category?.name ?? "")
                            .font(.headline)
                        StarRatingView(rating: Int(goal.category?.essentialDegree ?? 2))
                    }
                    Spacer()
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(15)
                .padding()
                
                    VStack(alignment: .leading){
                        Text("goals_tab_goal")
                            .font(.subheadline)
                        Text("\(goal.type == "less" ? NSLocalizedString("goals_tab_less_than_word", comment: "") : NSLocalizedString("goals_tab_more_than_word", comment: "")) \(tool.formatCurrencyMin(goal.sum) ?? "") \(NSLocalizedString("goals_tab_until_word", comment: "")) \(tool.formatDateMin(goal.deadline ?? Date()))")
                            .font(.title2)
                            .foregroundColor(.accentColor)
                        
                    }.padding(.horizontal).padding(.bottom)
                }
                
                if editMode{
                    
                    TextField("\(NSLocalizedString("word_name", comment: ""))", text: $goalNewName)
                        .padding()
                        .padding(.horizontal, 10)
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    VStack(alignment: .leading){ //  note text editor
                        Text("word_comment")
                            .font(.subheadline)
                        TextEditor(text: $goalNewComment)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .frame(height: 80)
                    }.padding()
                    
                    Spacer(minLength: 50)
                    
                    Button {
                        giveHapticFeedback()
                        goal.name = goalNewName
                        goal.comment = goalNewComment
                        goalsManager.updateGoal()
                        goalsManager.getGoalList()
                        editMode = false
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
                        goalNewName = goal.name ?? ""
                        goalNewComment = goal.comment ?? ""
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
                    
                    HStack{
                        Spacer()
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
                        Spacer()
                    }
                } else {
                    if goal.comment ?? "" != "" {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("word_comment")
                                .font(.subheadline)
                            Text(goal.comment ?? "")
                                .italic()
                                .font(.subheadline)
                                .multilineTextAlignment(.leading)
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                        }.padding(.horizontal).padding(.bottom)
                    }
                }
                if !editMode{
                    VStack(alignment: .leading, spacing: 10) {
                        Text("word_progress")
                            .font(.subheadline)
                        CircleProgressBarView(currentProgress: transactionManager.transactionsList.filter { $0.category == goal.category && $0.date ?? Date() >= goal.createDate ?? Date() && $0.date ?? Date() <= goal.deadline ?? Date() }.reduce(0) { $0 + $1.value }, maxProgress: goal.sum)
                            .padding()
                            .padding(.horizontal, 80)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(20)
                            .onAppear{
                                print(transactionManager.transactionsList.filter { $0.category == goal.category }.reduce(0) { $0 + $1.value })
                                print(goal.sum)
                            }
                    }
                    .padding(.horizontal)
                }
                    
                
            }
            .onAppear{
                goalNewName = goal.name ?? ""
                goalNewComment = goal.comment ?? ""
            }
            .navigationTitle(goalNewName)
            .hideKeyboardOnTap(excluding: [AnyView(TextField("\(NSLocalizedString("word_name", comment: ""))...", text: $goalNewName))])
            .toolbar {
                Button {
                    editMode.toggle()
                    giveHapticFeedback()
                    goalNewName = goal.name ?? ""
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
                        goalsManager.deleteGoal(goal: goal)
                        goalsManager.getGoalList()
                        presentationMode.wrappedValue.dismiss()
                    }),
                    secondaryButton: .cancel()
                )
            }
        }
    }
}


struct CircleProgressBarView: View {
    let currentProgress: Double
    let maxProgress: Double
    
    private var progressPercentage: Double {
        max(0, min(currentProgress / maxProgress, 1))
    }
    
    private var formattedProgress: String {
        String(format: "%.0f%%", progressPercentage * 100)
    }
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 29)
                    .opacity(0.3)
                    .foregroundColor(.gray)
                
                Circle()
                    .trim(from: 0, to: CGFloat(progressPercentage))
                    .stroke(style: StrokeStyle(lineWidth: 30, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.accentColor)
                    .rotationEffect(.degrees(-90))
                
                Text(formattedProgress)
                    .font(.title)
                    .bold()
            }
        }
    }
}
