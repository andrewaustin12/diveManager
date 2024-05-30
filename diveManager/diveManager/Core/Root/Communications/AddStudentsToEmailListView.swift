import SwiftUI

struct AddStudentsToEmailListView: View {
    @EnvironmentObject var dataModel: DataModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedStudents: Set<UUID>
    @Binding var emailList: EmailList

    var body: some View {
        NavigationView {
            List(dataModel.students) { student in
                Toggle("\(student.firstName) \(student.lastName)", isOn: Binding(
                    get: { self.selectedStudents.contains(student.id) },
                    set: { newValue in
                        if newValue {
                            self.selectedStudents.insert(student.id)
                            if !emailList.students.contains(where: { $0.id == student.id }) {
                                emailList.students.append(student)
                            }
                        } else {
                            self.selectedStudents.remove(student.id)
                            emailList.students.removeAll { $0.id == student.id }
                        }
                    }
                ))
            }
            .navigationTitle("Add Students")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct AddStudentsToEmailListView_Previews: PreviewProvider {
    static var previews: some View {
        AddStudentsToEmailListView(selectedStudents: .constant(Set(MockData.students.map { $0.id })), emailList: .constant(EmailList(name: "Sample List", students: MockData.students)))
            .environmentObject(DataModel())
    }
}
