import SwiftUI

struct EditEmailListView: View {
    @EnvironmentObject var dataModel: DataModel
    @Environment(\.presentationMode) var presentationMode
    @State var emailList: EmailList
    @State private var selectedStudents: Set<UUID> = []
    @State private var showingAddStudentSheet = false

    var body: some View {
        NavigationView {
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

                Section(header: Text("Add Students")) {
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
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingAddStudentSheet) {
                AddStudentsToEmailListView(selectedStudents: $selectedStudents, emailList: $emailList)
                    .environmentObject(dataModel)
            }
            .onAppear {
                self.selectedStudents = Set(emailList.students.map { $0.id })
            }
        }
    }

    private func removeStudent(_ student: Student) {
        emailList.students.removeAll { $0.id == student.id }
    }

    private func deleteStudent(at offsets: IndexSet) {
        emailList.students.remove(atOffsets: offsets)
    }

    private func saveChanges() {
        if let index = dataModel.emailLists.firstIndex(where: { $0.id == emailList.id }) {
            emailList.students = dataModel.students.filter { selectedStudents.contains($0.id) }
            dataModel.emailLists[index] = emailList
        }
    }
}


struct EditEmailListView_Previews: PreviewProvider {
    static var previews: some View {
        EditEmailListView(emailList: EmailList(name: "Sample List", students: MockData.students))
            .environmentObject(DataModel())
    }
}

