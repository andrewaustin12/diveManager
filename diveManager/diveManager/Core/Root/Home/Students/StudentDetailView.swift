import SwiftUI

struct StudentDetailView: View {
    @Binding var student: Student
    @State private var isEditing = false
    @State private var showingAddCertification = false

    // Temporary state for editing
    @State private var editedFirstName = ""
    @State private var editedLastName = ""
    @State private var editedEmail = ""
    @State private var editedStudentID = ""

    var body: some View {
        Form {
            if isEditing {
                Section(header: Text("Student Information")) {
                    TextField("First Name", text: $editedFirstName)
                    TextField("Last Name", text: $editedLastName)
                    TextField("Email", text: $editedEmail)
                    TextField("Student ID", text: $editedStudentID)
                }
            } else {
                Section(header: Text("Student Information")) {
                    Text(student.firstName)
                    Text(student.lastName)
                    Text(student.email)
                    Text(student.studentID)
                }
            }
            
            Section(header: Text("Certifications")) {
                ForEach(student.certifications) { certification in
                    VStack(alignment: .leading) {
                        Text(certification.name)
                            .font(.headline)
                        Text("Issued on \(certification.dateIssued, formatter: dateFormatter)")
                            .font(.subheadline)
                        Text("Agency: \(certification.agency.displayName)")
                            .font(.subheadline)
                    }
                }
                .onDelete(perform: deleteCertification)
            }
        }
        .navigationTitle(student.firstName)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isEditing {
                    Button(action: saveChanges) {
                        Text("Save")
                    }
                } else {
                    Menu {
                        Button(action: startEditing) {
                            Label("Edit Details", systemImage: "pencil")
                        }
                        Button(action: {
                            showingAddCertification = true
                        }) {
                            Label("Add Certification", systemImage: "plus")
                        }
                    } label: {
                        Label("More", systemImage: "ellipsis.circle")
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddCertification) {
            AddCertificationView(student: $student)
        }
    }

    private func startEditing() {
        editedFirstName = student.firstName
        editedLastName = student.lastName
        editedEmail = student.email
        editedStudentID = student.studentID
        isEditing = true
    }

    private func saveChanges() {
        student.firstName = editedFirstName
        student.lastName = editedLastName
        student.email = editedEmail
        student.studentID = editedStudentID
        isEditing = false
    }

    private func deleteCertification(at offsets: IndexSet) {
        student.certifications.remove(atOffsets: offsets)
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()

struct StudentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            StudentDetailView(
                student: .constant(
                    Student(
                        firstName: "John",
                        lastName: "Doe",
                        studentID: "123-456-7890",
                        email: "john@example.com",
                        certifications: [
                            Certification(name: "Open Water", dateIssued: Date(), agency: .padi)
                        ]
                    )
                )
            )
        }
    }
}
