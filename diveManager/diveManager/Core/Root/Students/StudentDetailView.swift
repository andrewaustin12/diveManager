import SwiftUI

struct StudentDetailView: View {
    @Binding var student: Student

    var body: some View {
        Form {
            Section(header: Text("Student Information")) {
                TextField("First Name", text: $student.firstName)
                TextField("Last Name", text: $student.lastName)
                TextField("Email", text: $student.email)
                TextField("Student ID", text: $student.studentID)
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
            }
        }
        .navigationTitle(student.firstName)
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
        StudentDetailView(
            student: .constant(
                Student(
                    firstName: "John",
                    lastName: "Doe",
                    studentID: "123-456-7890", 
                    email: "john@example.com"
                )
            )
        )
    }
}
