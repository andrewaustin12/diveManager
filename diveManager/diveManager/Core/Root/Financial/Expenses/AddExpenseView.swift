import SwiftUI

struct AddExpenseView: View {
    @EnvironmentObject var dataModel: DataModel
    @Environment(\.presentationMode) var presentationMode
    @State private var date = Date()
    @State private var selectedCategory: RevenueStream = .course
    @State private var amount: Double = 0.00
    @State private var description: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Expense Information")) {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(RevenueStream.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    HStack {
                        Text("Amount")
                        Spacer()
                        TextField("Enter an amount", value: $amount, format: .number)
                            .keyboardType(.decimalPad)
                    }
                    TextField("Description", text: $description)
                }
                
                //                Button(action: addExpense) {
                //                    Text("Add Expense")
                //                }
            }
            
            .navigationTitle("Add Expense")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
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
        
        let newExpense = Expense(category: selectedCategory, date: date, amount: amount, description: description)
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
