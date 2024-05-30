import SwiftUI

struct CommunicationsView: View {
    @State private var showingEmailStudentsView = false
    @State private var showingEmailListsView = false

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Communication Options")) {
                    NavigationLink(destination: EmailStudentsByCourseView()) {
                        Text("Email Students by Course")
                    }
                    NavigationLink(destination: EmailListsView()) {
                        Text("Manage Email Lists")
                    }
                }
            }
            .navigationTitle("Communications")
        }
    }
}

struct CommunicationsView_Previews: PreviewProvider {
    static var previews: some View {
        CommunicationsView()
            .environmentObject(DataModel())
    }
}
