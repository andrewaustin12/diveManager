import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.modelContext) private var context // Use SwiftData model context
    @Environment(\.dismiss) private var dismiss // Use dismiss environment action
    @State private var date = Date()
    @State private var amount: Double = 0.00
    @State private var expenseDescription: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Expense Information")) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    HStack {
                        Text("Amount")
                        Spacer()
                        TextField("Enter an amount", value: $amount, format: .number)
                            .keyboardType(.decimalPad)
                    }
                    TextField("Description", text: $expenseDescription)
                }
            }
            .navigationTitle("Add Expense")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        addExpense()
                    }
                }
            }
        }
    }

    private func addExpense() {
        let newExpense = Expense(date: date, amount: amount, expenseDescription: expenseDescription)
        context.insert(newExpense) // Insert the new expense into the SwiftData context
        do {
            try context.save() // Save the context
            dismiss()
        } catch {
            print("Failed to save new expense: \(error)")
        }
    }
}

struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Expense.self, configurations: config)
        
        AddExpenseView()
            .modelContainer(container) // Use model container for preview
    }
}
