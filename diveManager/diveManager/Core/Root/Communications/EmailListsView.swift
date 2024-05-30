import SwiftUI
import MessageUI

struct EmailListsView: View {
    @EnvironmentObject var dataModel: DataModel
    @State private var showingAddEmailListView = false
    @State private var showingMailCompose = false
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil
    @State private var selectedEmailList: EmailList?

    var body: some View {
        NavigationStack {
            List {
                ForEach(dataModel.emailLists) { emailList in
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
                    .environmentObject(dataModel)
            }
        }
    }

    private func deleteEmailList(at offsets: IndexSet) {
        dataModel.emailLists.remove(atOffsets: offsets)
    }
}

struct EmailListsView_Previews: PreviewProvider {
    static var previews: some View {
        EmailListsView()
            .environmentObject(DataModel())
    }
}
