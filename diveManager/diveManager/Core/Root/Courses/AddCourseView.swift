import SwiftUI

struct AddCourseView: View {
    @Binding var courses: [Course]
    @State private var name: String = ""
    @State private var diveShop: String = ""
    @State private var certificationAgency: String = ""
    @State private var isCompleted: Bool = false
    @State private var students: [Student] = []
    @State private var showingAddStudent = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Course Information")) {
                    TextField("Name", text: $name)
                    TextField("Dive Shop", text: $diveShop)
                    TextField("Certification Agency", text: $certificationAgency)
                    Toggle("Completed", isOn: $isCompleted)
                }
                
                Section(header: Text("Students")) {
                    ForEach(students) { student in
                        Text(student.firstName)
                    }
                    .onDelete(perform: deleteStudent)
                    
                    Button(action: { showingAddStudent = true }) {
                        Label("Add Student", systemImage: "plus")
                    }
                }
                
                Button(action: addCourse) {
                    Text("Add Course")
                }
            }
            .navigationTitle("Add Course")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingAddStudent) {
                AddStudentView(students: $students)
            }
        }
    }
    
    func addCourse() {
        let newCourse = Course(name: name,  students: students, sessions: [], diveShop: DiveShop(name: diveShop, location: ""), certificationAgency: CertificationAgency(name: certificationAgency, website: ""), isCompleted: isCompleted)
        courses.append(newCourse)
        presentationMode.wrappedValue.dismiss()
    }
    
    func deleteStudent(at offsets: IndexSet) {
        students.remove(atOffsets: offsets)
    }
}

struct AddCourseView_Previews: PreviewProvider {
    static var previews: some View {
        AddCourseView(courses: .constant([]))
    }
}
