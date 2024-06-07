import SwiftUI

struct AddCourseToInvoiceView: View {
    @Binding var course: Course
    @EnvironmentObject var dataModel: DataModel
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedInvoice: Invoice?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Select Invoice")) {
                    Picker("Invoice", selection: $selectedInvoice) {
                        ForEach(dataModel.invoices) { invoice in
                            Text(invoiceDescription(invoice)).tag(invoice as Invoice?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }
            .navigationTitle("Add Course to Invoice")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addCourseToInvoice()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(selectedInvoice == nil)
                }
            }
        }
    }

    private func invoiceDescription(_ invoice: Invoice) -> String {
        let formattedDate = shortDateFormatter.string(from: invoice.date)
        if let student = invoice.student {
            return "\(student.firstName) \(student.lastName) - \(formattedDate)"
        } else if let diveShop = invoice.diveShop {
            return "\(diveShop.name) - \(formattedDate)"
        } else {
            return "Invoice - \(formattedDate)"
        }
    }

    private func addCourseToInvoice() {
        guard let selectedInvoice = selectedInvoice else { return }

        let itemDescription = "\(course.selectedCourse) - \(course.students.count) students"
        let itemAmount = course.sessions.reduce(0) { $0 + Double($1.duration) * 50 } // Example calculation
        let newItem = InvoiceItem(description: itemDescription, amount: itemAmount, category: .course)

        if let index = dataModel.invoices.firstIndex(where: { $0.id == selectedInvoice.id }) {
            dataModel.invoices[index].items.append(newItem)
        }
    }
}

private let shortDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMM"
    return formatter
}()

struct AddCourseToInvoiceView_Previews: PreviewProvider {
    static var previews: some View {
        AddCourseToInvoiceView(course: .constant(MockData.courses[0]))
            .environmentObject(DataModel())
    }
}
