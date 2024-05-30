import SwiftUI

struct AddExpenseView: View {
    @EnvironmentObject var dataModel: DataModel
    @Environment(\.presentationMode) var presentationMode
    @State private var date = Date()
    @State private var amount: String = ""
    @State private var description: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Expense Information")) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    TextField("Description", text: $description)
                }

                Button(action: addExpense) {
                    Text("Add Expense")
                }
            }
            
            .navigationTitle("Add Expense")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }

    private func addExpense() {
        guard let amount = Double(amount) else { return }
        let newExpense = Expense(date: date, amount: amount, description: description)
        dataModel.expenses.append(newExpense)
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseView()
            .environmentObject(DataModel())
    }
}
