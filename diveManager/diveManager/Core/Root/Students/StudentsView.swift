import SwiftUI

struct StudentsView: View {
    @State private var students: [Student] = [
        Student(
            firstName: "John",
            lastName: "Doe",
            studentID: "123-456-7890",
            email: "john@example.com"
        )
    ]
    @State private var showingAddStudent = false
    @State private var selectedStudent: Student?

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach($students) { $student in
                        NavigationLink(destination: StudentDetailView(student: $student)) {
                            VStack(alignment: .leading) {
                                Text("\(student.firstName) \(student.lastName)")
                                    .font(.headline)
                                Text(student.email)
                                    .font(.subheadline)
                                Text(student.studentID)
                                    .font(.subheadline)
                            }
                        }
                    }
                    .onDelete(perform: deleteStudent)
                }
                .navigationTitle("Students")
                .toolbar {
                    Button(action: { showingAddStudent = true }) {
                        Label("Add Student", systemImage: "plus")
                    }
                }
                .sheet(isPresented: $showingAddStudent) {
                    AddStudentView(students: $students)
                }
            }
        }
    }

    func deleteStudent(at offsets: IndexSet) {
        students.remove(atOffsets: offsets)
    }
}

struct StudentsView_Previews: PreviewProvider {
    static var previews: some View {
        StudentsView()
    }
}
