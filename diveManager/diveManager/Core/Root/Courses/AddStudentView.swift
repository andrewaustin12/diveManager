import SwiftUI

struct AddStudentView: View {
    @Binding var students: [Student]
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var studentID: String = ""
    @State private var email: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Student Information")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Student ID", text: $studentID)
                    TextField("Email", text: $email)
                }
                
                Button(action: addStudent) {
                    Text("Add Student")
                }
            }
            .navigationTitle("Add Student")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    func addStudent() {
        let newStudent = Student(
            firstName: firstName,
            lastName: lastName,
            studentID: studentID,
            email: email,
            certifications: []
        )
        students.append(newStudent)
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddStudentView_Previews: PreviewProvider {
    static var previews: some View {
        AddStudentView(students: .constant([]))
    }
}
