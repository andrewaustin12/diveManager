import SwiftUI
import SwiftData

struct StudentsView: View {
    @Environment(\.modelContext) private var context
    @Query var students: [Student]
    @State private var showingAddStudent = false
    @State private var selectedStudents: [Student] = []
    @State private var searchQuery: String = ""

    var filteredStudents: [Student] {
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

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(filteredStudents, id: \.id) { student in
                        NavigationLink(destination: StudentDetailView(student: student)) {
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
                    AddNewStudentView(selectedStudents: $selectedStudents)
                        .environment(\.modelContext, context)
                }
            }
            .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search students")
        }
    }

    func deleteStudent(at offsets: IndexSet) {
        for index in offsets {
            let student = students[index]
            context.delete(student)
        }
        try? context.save()
    }
}

struct StudentsView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Student.self, configurations: config)
        
        return StudentsView()
            .modelContainer(container)
    }
}
