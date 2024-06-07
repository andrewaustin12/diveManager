import SwiftUI

struct ExistingStudentPickerView: View {
    let students: [Student]
    @Binding var selectedStudent: Student?
    @Environment(\.presentationMode) private var presentationMode
    var onStudentSelected: (Student) -> Void

    var body: some View {
        NavigationView {
            List(students) { student in
                Button(action: {
                    selectedStudent = student
                    onStudentSelected(student)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("\(student.firstName) \(student.lastName)")
                }
            }
            .navigationTitle("Select Existing Student")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
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
