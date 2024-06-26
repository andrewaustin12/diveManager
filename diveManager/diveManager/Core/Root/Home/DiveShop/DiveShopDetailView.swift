import SwiftUI
import SwiftData

struct DiveShopDetailView: View {
    @Environment(\.modelContext) private var context
    @Bindable var diveShop: DiveShop

    var body: some View {
        Form {
            Section(header: Text("Dive Shop Details")) {
                TextField("Name", text: $diveShop.name)
                TextField("Address", text: $diveShop.address)
                TextField("Phone", text: $diveShop.phone)
                TextField("Email", text: $diveShop.email)
            }
        }
        .navigationTitle("Dive Shop Details")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Save") {
                    saveDiveShop()
                }
            }
        }
    }

    private func saveDiveShop() {
        // Save changes to the context
        try? context.save()
    }
}


struct DiveShopDetailView_Previews: PreviewProvider {
    @State static var diveShop = MockData.diveShops[0]

    static var previews: some View {
        NavigationStack {
            DiveShopDetailView(diveShop: diveShop)
        }
    }
}
