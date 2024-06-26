import SwiftUI
import SwiftData

struct AddEmailListView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var listName: String = ""
    @State private var selectedStudents: Set<UUID> = []
    @State private var showingAddStudents = false
    @Query private var students: [Student]

    var selectedStudentList: [Student] {
        students.filter { selectedStudents.contains($0.id) }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("List Information")) {
                    TextField("List Name", text: $listName)
                }

                Section(header: Text("Add Students")) {
                    Button(action: { showingAddStudents = true }) {
                        Label("Add Students", systemImage: "plus")
                    }

                    ForEach(selectedStudentList) { student in
                        Text("\(student.firstName) \(student.lastName)")
                    }
                }

                Button(action: addEmailList) {
                    Text("Create List")
                        .font(.headline)
                }
                .disabled(listName.isEmpty || selectedStudents.isEmpty)
            }
            .navigationTitle("New Email List")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingAddStudents) {
                AddStudentsToEmailListView(selectedStudents: $selectedStudents)
                    .environment(\.modelContext, context)
            }
        }
    }

    private func addEmailList() {
        let newEmailList = EmailList(name: listName, students: [])
        context.insert(newEmailList)

        for studentID in selectedStudents {
            if let student = students.first(where: { $0.id == studentID }) {
                newEmailList.students.append(student)
            }
        }

        do {
            try context.save()
        } catch {
            print("Failed to save new email list: \(error)")
        }
        dismiss()
    }
}

struct AddEmailListView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: EmailList.self, Student.self, configurations: config)

        AddEmailListView()
            .modelContainer(container)
    }
}
