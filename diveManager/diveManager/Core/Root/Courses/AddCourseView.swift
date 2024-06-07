import SwiftUI

struct AddCourseView: View {
    @EnvironmentObject var dataModel: DataModel
    @Binding var courses: [Course]
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedDiveShop: DiveShop?
    @State private var selectedAgency: CertificationAgency = .padi
    @State private var selectedCourse: String = CertificationAgency.PADI.openWater.rawValue
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var isCompleted: Bool = false
    @State private var students: [Student] = []
    @State private var showingAddStudent = false
    
    var isAddCourseButtonDisabled: Bool {
        selectedDiveShop == nil || selectedCourse.isEmpty
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Course Information")) {
                    Picker("Dive Shop", selection: $selectedDiveShop) {
                        ForEach(dataModel.diveShops) { diveShop in
                            Text(diveShop.name).tag(diveShop as DiveShop?)
                        }
                    }
                    
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
                    .onChange(of: selectedAgency) { newValue in
                        selectedCourse = newValue.getCourses().first ?? ""
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
            }
            .navigationTitle("Add Course")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: addCourse) {
                        Text("Add Course")
                    }
                    .disabled(isAddCourseButtonDisabled)
                }
            }
            .sheet(isPresented: $showingAddStudent) {
                AddStudentView(students: $students)
                    .environmentObject(DataModel())
            }
        }
    }
    
    func addCourse() {
        let newCourse = Course(
            students: students,
            startDate: startDate,
            endDate: endDate,
            sessions: [],
            diveShop: selectedDiveShop!,
            certificationAgency: selectedAgency,
            selectedCourse: selectedCourse,
            isCompleted: isCompleted
        )
        print(newCourse)
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
