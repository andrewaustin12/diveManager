import SwiftUI

struct ExistingStudentPickerView: View {
    let students: [Student]
    @Binding var selectedStudent: Student?
    var onStudentSelected: (Student) -> Void

    var body: some View {
        NavigationView {
            List(students) { student in
                Button(action: {
                    selectedStudent = student
                    onStudentSelected(student)
                }) {
                    Text("\(student.firstName) \(student.lastName)")
                }
            }
            .navigationTitle("Select Existing Student")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        selectedStudent = nil
                        onStudentSelected(Student(firstName: "", lastName: "", studentID: "", email: "", certifications: []))
                    }
                }
            }
        }
    }
}

struct ExistingStudentPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ExistingStudentPickerView(students: MockData.students, selectedStudent: .constant(nil)) { _ in }
    }
}
