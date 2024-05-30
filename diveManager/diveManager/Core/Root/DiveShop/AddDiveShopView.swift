import SwiftUI

struct AddDiveShopView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var diveShops: [DiveShop]
    @State private var name: String = ""
    @State private var address: String = ""
    @State private var phone: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Dive Shop Information")) {
                    TextField("Name", text: $name)
                    TextField("Address", text: $address)
                    TextField("Phone", text: $phone)
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
                        let newDiveShop = DiveShop(name: name, address: address, phone: phone)
                        diveShops.append(newDiveShop)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(name.isEmpty || address.isEmpty || phone.isEmpty)
                }
            }
        }
    }
}

struct AddDiveShopView_Previews: PreviewProvider {
    static var previews: some View {
        AddDiveShopView(diveShops: .constant([DiveShop(name: "Sample Shop", address: "123 Ocean Ave", phone: "123-456-7890")]))
    }
}
