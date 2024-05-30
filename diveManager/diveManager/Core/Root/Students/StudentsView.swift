import SwiftUI

struct StudentsView: View {
    @State private var students: [Student] = MockData.students
    @State private var showingAddStudent = false
    @State private var selectedStudent: Student?
    @State private var searchQuery: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(filteredStudents()) { student in
                        NavigationLink(destination: StudentDetailView(student: binding(for: student))) {
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
            .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search students")
        }
    }

    func deleteStudent(at offsets: IndexSet) {
        students.remove(atOffsets: offsets)
    }

    private func filteredStudents() -> [Student] {
        if searchQuery.isEmpty {
            return students
        } else {
            return students.filter { student in
                student.firstName.localizedCaseInsensitiveContains(searchQuery) ||
                student.lastName.localizedCaseInsensitiveContains(searchQuery) ||
                student.studentID.localizedCaseInsensitiveContains(searchQuery) ||
                student.email.localizedCaseInsensitiveContains(searchQuery) ||
                student.certifications.map { $0.name }.joined(separator: " ").localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }

    private func binding(for student: Student) -> Binding<Student> {
        guard let index = students.firstIndex(where: { $0.id == student.id }) else {
            fatalError("Student not found")
        }
        return $students[index]
    }
}

struct StudentsView_Previews: PreviewProvider {
    static var previews: some View {
        StudentsView()
    }
}
