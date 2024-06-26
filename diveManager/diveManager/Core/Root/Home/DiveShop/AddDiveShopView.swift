import SwiftUI
import SwiftData

struct AddDiveShopView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var context
    @State private var name: String = ""
    @State private var address: String = ""
    @State private var phone: String = ""
    @State private var email: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Dive Shop Information")) {
                    TextField("Name", text: $name)
                    TextField("Address", text: $address)
                    TextField("Phone", text: $phone)
                    TextField("Email", text: $email)
                }
            }
            .navigationTitle("Add Dive Shop")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newDiveShop = DiveShop(name: name, address: address, phone: phone, email: email)
                        context.insert(newDiveShop)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(name.isEmpty || address.isEmpty || phone.isEmpty || email.isEmpty)
                }
            }
        }
    }
}

struct AddDiveShopView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: DiveShop.self, configurations: config)
        
        return AddDiveShopView()
            .modelContainer(container)
    }
}
