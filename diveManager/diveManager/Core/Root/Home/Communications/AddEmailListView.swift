import SwiftUI

struct AddEmailListView: View {
    @EnvironmentObject var dataModel: DataModel
    @Environment(\.presentationMode) var presentationMode
    @State private var listName: String = ""
    @State private var searchQuery: String = ""
    @State private var selectedStudents: Set<Student> = []
    @State private var showingAddStudent = false

    var filteredStudents: [Student] {
        if searchQuery.isEmpty {
            return dataModel.students
        } else {
            return dataModel.students.filter { student in
                student.firstName.localizedCaseInsensitiveContains(searchQuery) ||
                student.lastName.localizedCaseInsensitiveContains(searchQuery) ||
                student.email.localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("List Information")) {
                    TextField("List Name", text: $listName)
                }
                
                Section(header: Text("Add Students")) {
                    Button(action: { showingAddStudent = true }) {
                        Label("Add Student", systemImage: "plus")
                    }
                }
                
                Button(action: addEmailList) {
                    Text("Create List")
                        .font(.headline)
                }
            }
            .navigationTitle("New Email List")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }

    private func addEmailList() {
        let newEmailList = EmailList(name: listName, students: Array(selectedStudents))
        dataModel.emailLists.append(newEmailList)
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddEmailListView_Previews: PreviewProvider {
    static var previews: some View {
        AddEmailListView()
            .environmentObject(DataModel())
    }
}
