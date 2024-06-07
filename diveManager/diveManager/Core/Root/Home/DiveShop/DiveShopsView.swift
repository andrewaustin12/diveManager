import SwiftUI

struct DiveShopsView: View {
    @State private var diveShops: [DiveShop] = MockData.diveShops
    @State private var showingAddDiveShop = false
    @State private var searchQuery: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(filteredDiveShops()) { diveShop in
                        NavigationLink(destination: DiveShopDetailView(diveShop: binding(for: diveShop))) {
                            VStack(alignment: .leading) {
                                Text(diveShop.name)
                                    .font(.headline)
                                Text(diveShop.address)
                                    .font(.subheadline)
                                Text(diveShop.phone)
                                    .font(.subheadline)
                            }
                        }
                    }
                    .onDelete(perform: deleteDiveShop)
                }
                .navigationTitle("Dive Shops")
                .toolbar {
                    Button(action: { showingAddDiveShop = true }) {
                        Label("Add Dive Shop", systemImage: "plus")
                    }
                }
                .sheet(isPresented: $showingAddDiveShop) {
                    AddDiveShopView(diveShops: $diveShops)
                }
            }
            .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search dive shops")
        }
    }

    func deleteDiveShop(at offsets: IndexSet) {
        diveShops.remove(atOffsets: offsets)
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

    private func binding(for diveShop: DiveShop) -> Binding<DiveShop> {
        guard let index = diveShops.firstIndex(where: { $0.id == diveShop.id }) else {
            fatalError("Dive Shop not found")
        }
        return $diveShops[index]
    }
}

struct DiveShopsView_Previews: PreviewProvider {
    static var previews: some View {
        DiveShopsView()
            .environmentObject(DataModel())
    }
}
