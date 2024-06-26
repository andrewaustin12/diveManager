import SwiftUI
import SwiftData

struct EmailListsView: View {
    @Environment(\.modelContext) private var context
    @Query var emailLists: [EmailList]
    @State private var showingAddEmailListView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if emailLists.isEmpty {
                    ContentUnavailableView {
                        Label("No Lists Available", systemImage: "tray")
                    } description: {
                        Text("Please add new lists.")
                    } 
                } else {
                    List {
                        ForEach(emailLists) { emailList in
                            NavigationLink(destination: EmailListDetailView(emailList: emailList)) {
                                VStack(alignment: .leading) {
                                    Text(emailList.name)
                                        .font(.headline)
                                    Text("Students: \(emailList.students.count)")
                                        .font(.subheadline)
                                }
                            }
                        }
                        .onDelete(perform: deleteEmailList)
                    }
                }
            }
            .navigationTitle("Email Lists")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddEmailListView = true }) {
                        Label("Add List", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddEmailListView) {
                AddEmailListView()
            }
        }
    }
    
    private func deleteEmailList(at offsets: IndexSet) {
        for index in offsets {
            let emailList = emailLists[index]
            context.delete(emailList)
        }
    }
}

struct EmailListsView_Previews: PreviewProvider {
    static var previews: some View {
        EmailListsView()
            .modelContainer(for: [EmailList.self, Student.self, Certification.self])
    }
}
