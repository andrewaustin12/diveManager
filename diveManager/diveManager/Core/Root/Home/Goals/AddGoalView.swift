import SwiftUI
import SwiftData

struct AddGoalView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context

    @State private var selectedGoalCategory: GoalCategory = .revenue
    @State private var amount: String = ""
    @State private var selectedGoalType: GoalType = .monthly
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    @State private var selectedQuarter: Int = 1

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Goal Details")) {
                    Picker("Goal Category", selection: $selectedGoalCategory) {
                        ForEach(GoalCategory.allCases) { category in
                            Text(category.rawValue.capitalized).tag(category)
                        }
                    }
                    
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    
                    Picker("Goal Type", selection: $selectedGoalType) {
                        Text("Monthly").tag(GoalType.monthly)
                        Text("Quarterly").tag(GoalType.quarterly)
                        Text("Yearly").tag(GoalType.yearly)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                if selectedGoalType == .monthly {
                    Section(header: Text("Monthly Goal")) {
                        Picker("Month", selection: $selectedMonth) {
                            ForEach(1...12, id: \.self) { month in
                                Text(Calendar.current.monthSymbols[month - 1]).tag(month)
                            }
                        }
                        
                        Picker("Year", selection: $selectedYear) {
                            ForEach((2023...2035), id: \.self) { year in
                                Text(String(year)).tag(year)
                            }
                        }
                    }
                }

                if selectedGoalType == .quarterly {
                    Section(header: Text("Quarterly Goal")) {
                        Picker("Quarter", selection: $selectedQuarter) {
                            Text("Q1").tag(1)
                            Text("Q2").tag(2)
                            Text("Q3").tag(3)
                            Text("Q4").tag(4)
                        }

                        Picker("Year", selection: $selectedYear) {
                            ForEach((2023...2035), id: \.self) { year in
                                Text(String(year)).tag(year)
                            }
                        }
                    }
                }

                if selectedGoalType == .yearly {
                    Section(header: Text("Yearly Goal")) {
                        Picker("Year", selection: $selectedYear) {
                            ForEach((2023...2035), id: \.self) { year in
                                Text(String(year)).tag(year)
                            }
                        }
                    }
                }
                
                Button(action: {
                    addGoal()
                    dismiss()
                }) {
                    Text("Add Goal")
                }
                .disabled(amount.isEmpty)
            }
            .navigationTitle("Add Goal")
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
        }
    }
    
    private func addGoal() {
        guard let amount = Double(amount) else { return }
        
        let newGoal = Goal(amount: amount, type: selectedGoalType, category: selectedGoalCategory, year: selectedYear, month: selectedGoalType == .monthly ? selectedMonth : nil, quarter: selectedGoalType == .quarterly ? selectedQuarter : nil)
        context.insert(newGoal)
        do {
            try context.save()
        } catch {
            print("Failed to save goal: \(error)")
        }
    }
}

struct AddGoalView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Goal.self, configurations: config)

        return AddGoalView()
            .modelContainer(container)
    }
}
