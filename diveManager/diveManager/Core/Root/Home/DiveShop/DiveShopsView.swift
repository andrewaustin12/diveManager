import SwiftUI
import SwiftData

struct DiveShopsView: View {
    @Environment(\.modelContext) private var context
    @Query var diveShops: [DiveShop]
    @State private var showingAddDiveShop = false
    @State private var searchQuery: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(filteredDiveShops(), id: \.id) { diveShop in
                        NavigationLink(destination: DiveShopDetailView(diveShop: diveShop)) {
                            VStack(alignment: .leading) {
                                Text(diveShop.name)
                                    .font(.headline)
                                Text(diveShop.address)
                                    .font(.subheadline)
                                Text(diveShop.phone)
                                    .font(.subheadline)
                                Text(diveShop.email)
                                    .font(.subheadline)
                            }
                        }
                    }
                    .onDelete(perform: deleteDiveShop)
                }
                .navigationTitle("Dive Shops")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showingAddDiveShop = true }) {
                            Label("Add Dive Shop", systemImage: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showingAddDiveShop) {
                    AddDiveShopView()
                }
            }
            .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search dive shops")
        }
    }

    private func deleteDiveShop(at offsets: IndexSet) {
        for index in offsets {
            let diveShop = diveShops[index]
            context.delete(diveShop)
        }
        try? context.save()
    }

    private func filteredDiveShops() -> [DiveShop] {
        if searchQuery.isEmpty {
            return diveShops
        } else {
            return diveShops.filter { diveShop in
                diveShop.name.localizedCaseInsensitiveContains(searchQuery) ||
                diveShop.address.localizedCaseInsensitiveContains(searchQuery) ||
                diveShop.phone.localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }
}

struct DiveShopsView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: DiveShop.self, configurations: config)
        
        return DiveShopsView()
            .modelContainer(container)
    }
}
