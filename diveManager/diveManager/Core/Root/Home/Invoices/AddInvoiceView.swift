import SwiftUI

struct AddInvoiceView: View {
    @EnvironmentObject var dataModel: DataModel
    @Binding var invoices: [Invoice]
    @Environment(\.presentationMode) var presentationMode
    @State private var billingType: BillingType = .student
    @State private var selectedStudent: Student? = MockData.students.first
    @State private var diveShopName: String = ""
    @State private var date: Date = Date()
    @State private var dueDate: Date = Calendar.current.date(byAdding: .day, value: 30, to: Date())!
    @State private var amount: String = ""
    @State private var isPaid: Bool = false
    @State private var items: [InvoiceItem] = []
    @State private var newItemDescription: String = ""
    @State private var newItemAmount: String = ""
    @State private var selectedCategory: RevenueStream = .course
    @State private var showingReminderSheet = false
    @State private var reminderDate = Date()
    @State private var showingAddItemView = false

    var allFieldsFilled: Bool {
        if billingType == .student {
            return selectedStudent != nil && !amount.isEmpty && !items.isEmpty
        } else {
            return !diveShopName.isEmpty && !amount.isEmpty && !items.isEmpty
        }
    }

    var body: some View {
        NavigationStack {
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
                        TextField("Dive Shop", text: $diveShopName)
                    }

                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)

                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)

                    Toggle("Paid", isOn: $isPaid)
                }

                Section(header: HStack {
                    Text("Items")
                    Spacer()
                    Button(action: {
                        showingAddItemView = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }) {
                    ForEach(items) { item in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(item.description)
                                Spacer()
                                Text("$\(item.amount, specifier: "%.2f")")
                            }
                        }
                    }
                    .onDelete(perform: deleteItem)

                    
                }
                
                Section(header: Text("Reminder")) {
                    Button(action: {
                        showingReminderSheet = true
                    }) {
                        HStack {
                            Spacer()
                            Text("Set Reminder")
                                .font(.headline)
                                .foregroundColor(.blue)
                            Spacer()
                        }
                    }
                    if reminderDate != Date() {
                        HStack {
                            Text("Reminder Set For")
                            Spacer()
                            Text(formattedDate(reminderDate))
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Add Invoice")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: addInvoice) {
                        Text("Add Invoice")
                    }
                    .disabled(!allFieldsFilled)
                }
            }
            .sheet(isPresented: $showingReminderSheet) {
                ReminderSheet(notificationDate: $reminderDate, onSetReminder: { reminderDate = $0; showingReminderSheet = false })
            }
            .sheet(isPresented: $showingAddItemView) {
                AddInvoiceItemView(items: $items)
                    }
        }
    }

    func addItem() {
        guard !newItemDescription.isEmpty, let amount = Double(newItemAmount) else { return }
        let newItem = InvoiceItem(description: newItemDescription, amount: amount, category: selectedCategory)
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
            newInvoice = Invoice(student: selectedStudent, diveShop: nil, date: date, dueDate: dueDate, amount: amount, isPaid: isPaid, billingType: .student, items: items, reminderDate: reminderDate)
        } else if billingType == .diveShop {
            let diveShop = DiveShop(name: diveShopName, address: "", phone: "")
            newInvoice = Invoice(student: nil, diveShop: diveShop, date: date, dueDate: dueDate, amount: amount, isPaid: isPaid, billingType: .diveShop, items: items, reminderDate: reminderDate)
        } else {
            return
        }
        
        invoices.append(newInvoice)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct AddInvoiceView_Previews: PreviewProvider {
    static var previews: some View {
        AddInvoiceView(invoices: .constant([]))
    }
}
