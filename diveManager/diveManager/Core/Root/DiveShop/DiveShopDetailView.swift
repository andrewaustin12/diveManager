import SwiftUI

struct DiveShopDetailView: View {
    @Binding var diveShop: DiveShop
    @State private var isEditing = false

    var body: some View {
        Form {
            Section(header: Text("Dive Shop Information")) {
                TextField("Name", text: $diveShop.name)
                    .disabled(!isEditing)
                TextField("Address", text: $diveShop.address)
                    .disabled(!isEditing)
                TextField("Phone", text: $diveShop.phone)
                    .disabled(!isEditing)
            }
        }
        .navigationTitle(diveShop.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isEditing.toggle()
                }) {
                    Text(isEditing ? "Done" : "Edit")
                }
            }
        }
    }
}

struct DiveShopDetailView_Previews: PreviewProvider {
    @State static var diveShop = MockData.diveShops[0]

    static var previews: some View {
        NavigationStack {
            DiveShopDetailView(diveShop: $diveShop)
        }
    }
}
