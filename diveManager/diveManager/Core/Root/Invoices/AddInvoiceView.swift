import SwiftUI

struct AddInvoiceView: View {
    @Binding var invoices: [Invoice]
    @Environment(\.presentationMode) var presentationMode
    @State private var billingType: BillingType = .student
    @State private var selectedStudent: Student? = MockData.students.first
    @State private var selectedDiveShop: DiveShop? = MockData.diveShops.first
    @State private var date: Date = Date()
    @State private var dueDate: Date = Calendar.current.date(byAdding: .day, value: 30, to: Date())!
    @State private var amount: String = ""
    @State private var isPaid: Bool = false
    @State private var items: [InvoiceItem] = []
    @State private var newItemDescription: String = ""
    @State private var newItemAmount: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Invoice Information")) {
                    Picker("Billing Type", selection: $billingType) {
                        ForEach(BillingType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if billingType == .student {
                        Picker("Student", selection: $selectedStudent) {
                            ForEach(MockData.students) { student in
                                Text("\(student.firstName) \(student.lastName)").tag(student as Student?)
                            }
                        }
                    } else {
                        Picker("Dive Shop", selection: $selectedDiveShop) {
                            ForEach(MockData.diveShops) { diveShop in
                                Text(diveShop.name).tag(diveShop as DiveShop?)
                            }
                        }
                    }

                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)

                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)

                    Toggle("Paid", isOn: $isPaid)
                }

                Section(header: Text("Itemized Breakdown")) {
                    ForEach(items) { item in
                        HStack {
                            Text(item.description)
                            Spacer()
                            Text("$\(item.amount, specifier: "%.2f")")
                        }
                    }
                    .onDelete(perform: deleteItem)

                    HStack {
                        TextField("Description", text: $newItemDescription)
                        TextField("Amount", text: $newItemAmount)
                            .keyboardType(.decimalPad)
                        Button(action: addItem) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                }

                Button(action: addInvoice) {
                    Text("Add Invoice")
                }
            }
            .navigationTitle("Add Invoice")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }

    func addItem() {
        guard !newItemDescription.isEmpty, let amount = Double(newItemAmount) else { return }
        let newItem = InvoiceItem(description: newItemDescription, amount: amount)
        items.append(newItem)
        newItemDescription = ""
        newItemAmount = ""
    }

    func deleteItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }

    func addInvoice() {
        guard let amount = Double(amount) else { return }
        
        let newInvoice: Invoice
        
        if billingType == .student, let selectedStudent = selectedStudent {
            newInvoice = Invoice(student: selectedStudent, diveShop: nil, date: date, dueDate: dueDate, amount: amount, isPaid: isPaid, billingType: .student, items: items)
        } else if billingType == .diveShop, let selectedDiveShop = selectedDiveShop {
            newInvoice = Invoice(student: nil, diveShop: selectedDiveShop, date: date, dueDate: dueDate, amount: amount, isPaid: isPaid, billingType: .diveShop, items: items)
        } else {
            return
        }
        
        invoices.append(newInvoice)
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddInvoiceView_Previews: PreviewProvider {
    static var previews: some View {
        AddInvoiceView(invoices: .constant([]))
    }
}
