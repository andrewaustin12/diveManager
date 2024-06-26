import SwiftUI
import UserNotifications
import SwiftData

struct AddCourseView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDiveShop: DiveShop?
    @State private var selectedAgency: CertificationAgency = .padi
    @State private var selectedCourse: String = CertificationAgency.padi.getCourses().first ?? ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var isCompleted: Bool = false
    @State private var students: [Student] = []
    @State private var showingAddStudent = false
    @Query private var diveShops: [DiveShop]
    
    var isAddCourseButtonDisabled: Bool {
        selectedDiveShop == nil || selectedCourse.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Course Information")) {
                    Picker("Dive Shop", selection: $selectedDiveShop) {
                        ForEach(diveShops) { diveShop in
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
                        Text("\(student.firstName) \(student.lastName)")
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
                        dismiss()
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
                AddStudentView(selectedStudents: $students)
            }
        }
    }
    
    func addCourse() {
        guard let selectedDiveShop = selectedDiveShop else { return }
        
        let newCourse = Course(
            students: [],
            startDate: startDate,
            endDate: endDate,
            sessions: [],
            diveShop: selectedDiveShop,
            certificationAgency: selectedAgency,
            selectedCourse: selectedCourse,
            isCompleted: isCompleted
        )
        
        context.insert(newCourse)
        
        // Add students to the course
        for student in students {
            if let existingStudent = fetchExistingStudent(matching: student) {
                // If the student already exists in the context, use that instance
                newCourse.students.append(existingStudent)
            } else {
                // If the student doesn't exist, insert it into the context
                context.insert(student)
                newCourse.students.append(student)
            }
        }
        
        scheduleCourseCompletionNotification(for: newCourse)
        
        dismiss()
    }

    // Helper function to fetch existing students
    private func fetchExistingStudent(matching student: Student) -> Student? {
        let predicate = #Predicate<Student> { $0.id == student.id }
        let descriptor = FetchDescriptor(predicate: predicate)
        return try? context.fetch(descriptor).first
    }
    
    func deleteStudent(at offsets: IndexSet) {
        students.remove(atOffsets: offsets)
    }
    
    private func scheduleCourseCompletionNotification(for course: Course) {
        let content = UNMutableNotificationContent()
        content.title = "Course Completed"
        content.body = "The course \(course.selectedCourse) at \(course.diveShop?.name ?? "Dive Shop") has finished. Don't forget to add it to the invoice."
        content.sound = .default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: course.endDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for course: \(course.selectedCourse)")
            }
        }
    }
}

struct AddCourseView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Course.self, DiveShop.self, Student.self, configurations: config)
        
        AddCourseView()
            .modelContainer(container)
    }
}
