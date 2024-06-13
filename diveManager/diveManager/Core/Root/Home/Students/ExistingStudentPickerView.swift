import SwiftUI

struct ExistingStudentPickerView: View {
    let students: [Student]
    @Binding var selectedStudent: Student?
    @State private var searchText = ""
    @Environment(\.presentationMode) private var presentationMode
    var onStudentSelected: (Student) -> Void

    var body: some View {
        NavigationStack {
            List(students) { student in
                Button(action: {
                    selectedStudent = student
                    onStudentSelected(student)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("\(student.firstName) \(student.lastName)")
                        .foregroundStyle(.primary)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .searchable(text: $searchText)
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
