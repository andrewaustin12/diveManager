import SwiftUI

struct AddInvoiceItemView: View {
    @Binding var items: [InvoiceItem]
    @Environment(\.presentationMode) var presentationMode
    @State private var newItemDescription: String = ""
    @State private var newItemAmount: String = ""
    @State private var selectedCategory: RevenueStream = .course

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Item Details")) {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(RevenueStream.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    TextField("Description", text: $newItemDescription)
                    TextField("Amount", text: $newItemAmount)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationBarTitle("Add Invoice Item", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    addItem()
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(newItemDescription.isEmpty || newItemAmount.isEmpty)
            )
        }
    }

    func addItem() {
            guard !newItemDescription.isEmpty, let amount = Double(newItemAmount) else { return }
            let newItem = InvoiceItem(description: newItemDescription, amount: amount, category: selectedCategory)
            items.append(newItem)
            newItemDescription = ""
            newItemAmount = ""
        }
}

struct AddInvoiceItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddInvoiceItemView(items: .constant([]))
    }
}
