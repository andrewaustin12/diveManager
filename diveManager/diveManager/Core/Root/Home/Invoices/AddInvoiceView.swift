import SwiftUI
import SwiftData

struct AddInvoiceView: View {
    @Environment(\.modelContext) private var context // Use the SwiftData model context environment
    @Environment(\.dismiss) private var dismiss // Use dismiss environment action
    @State private var billingType: BillingType = .student
    @Query private var students: [Student]
    @Query private var diveShops: [DiveShop] // Use SwiftData query to fetch dive shops
    @State private var selectedStudent: Student?
    @State private var selectedDiveShop: DiveShop?
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
            return selectedDiveShop != nil && !amount.isEmpty && !items.isEmpty
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
                            ForEach(students) { student in
                                Text("\(student.firstName) \(student.lastName)").tag(student as Student?)
                            }
                        }
                    } else {
                        Picker("Dive Shop", selection: $selectedDiveShop) {
                            ForEach(diveShops) { diveShop in
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
                                Text(item.itemDescription)
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
                        dismiss()
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
        let newItem = InvoiceItem(itemDescription: newItemDescription, amount: amount, category: selectedCategory)
        items.append(newItem)
        newItemDescription = ""
        newItemAmount = ""
    }

    func deleteItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }

    func addInvoice() {
        guard let amountValue = Double(amount) else { return }
        let newInvoice: Invoice

        if billingType == .student, let selectedStudent = selectedStudent {
            newInvoice = Invoice(student: selectedStudent, diveShop: nil, date: date, dueDate: dueDate, isPaid: isPaid, billingType: .student, amount: amountValue, items: items, reminderDate: reminderDate)
        } else if billingType == .diveShop, let selectedDiveShop = selectedDiveShop {
            newInvoice = Invoice(student: nil, diveShop: selectedDiveShop, date: date, dueDate: dueDate, isPaid: isPaid, billingType: .diveShop, amount: amountValue, items: items, reminderDate: reminderDate)
        } else {
            return
        }

        context.insert(newInvoice) // Insert the new invoice into the SwiftData context
        do {
            try context.save() // Save the context
        } catch {
            print("Failed to save new invoice: \(error)")
        }

        dismiss()
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct AddInvoiceView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Invoice.self, DiveShop.self, configurations: config)

        AddInvoiceView()
            .modelContainer(container) // Use model container for preview
    }
}
 
