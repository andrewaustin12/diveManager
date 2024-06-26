import SwiftUI
import SwiftData

struct EditEmailListView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State var emailList: EmailList
    @State private var selectedStudents: Set<UUID> = []
    @State private var showingAddStudentSheet = false
    @Query private var students: [Student]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("List Information")) {
                    TextField("List Name", text: $emailList.name)
                }

                Section(header: Text("Students in List")) {
                    ForEach(emailList.students) { student in
                        HStack {
                            Text("\(student.firstName) \(student.lastName)")
                            Spacer()
                            Button(action: {
                                removeStudent(student)
                            }) {
                                Image(systemName: "minus.circle")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .onDelete(perform: deleteStudent)
                }

                Section(header: Text("Add Individual Students")) {
                    Button(action: {
                        showingAddStudentSheet = true
                    }) {
                        Label("Add Student", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Edit Email List")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingAddStudentSheet) {
                AddStudentsToEmailListView(selectedStudents: $selectedStudents)
                    .environment(\.modelContext, context)
                    .onDisappear {
                        updateEmailListWithSelectedStudents()
                    }
            }
            .onAppear {
                self.selectedStudents = Set(emailList.students.map { $0.id })
            }
        }
    }

    private func removeStudent(_ student: Student) {
        emailList.students.removeAll { $0.id == student.id }
        selectedStudents.remove(student.id)
    }

    private func deleteStudent(at offsets: IndexSet) {
        for index in offsets {
            let student = emailList.students[index]
            removeStudent(student)
        }
    }

    private func saveChanges() {
        updateEmailListWithSelectedStudents()
        
        do {
            try context.save()
        } catch {
            print("Failed to save email list changes: \(error)")
        }
    }

    private func updateEmailListWithSelectedStudents() {
        for studentID in selectedStudents {
            if let student = students.first(where: { $0.id == studentID }) {
                if !emailList.students.contains(where: { $0.id == student.id }) {
                    emailList.students.append(student)
                }
            }
        }
    }
}

struct EditEmailListView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: EmailList.self, Student.self, configurations: config)

        EditEmailListView(emailList: EmailList(name: "Sample List", students: []))
            .modelContainer(container)
    }
}
