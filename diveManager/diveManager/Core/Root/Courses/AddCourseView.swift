import SwiftUI

struct AddCourseView: View {
    @Binding var courses: [Course]
    @State private var diveShop: String = ""
    @State private var selectedAgency: CertificationAgency = .padi
    @State private var selectedCourse: String = CertificationAgency.PADI.openWater.rawValue
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var isCompleted: Bool = false
    @State private var students: [Student] = []
    @State private var showingAddStudent = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Course Information")) {
                    TextField("Dive Shop", text: $diveShop)
                    
                    Picker("Certification Agency", selection: $selectedAgency) {
                        ForEach(CertificationAgency.allCases) { agency in
                            Text(agency.displayName).tag(agency)
                        }
                    }
                    
                    Picker("Course", selection: $selectedCourse) {
                        ForEach(selectedAgency.getCourses(), id: \.self) { course in
                            Text(course).tag(course)
                        }
                    }
                    .onChange(of: selectedAgency) { _ in
                        selectedCourse = selectedAgency.getCourses().first ?? ""
                    }
                    
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                    
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
        let newCourse = Course(
            students: students,
            sessions: [],
            diveShop: DiveShop(name: diveShop, location: ""),
            certificationAgency: selectedAgency,
            courseName: selectedCourse,
            startDate: startDate,
            endDate: endDate,
            isCompleted: isCompleted
        )
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
