import SwiftUI

struct CourseDetailView: View {
    @Binding var course: Course
    @State private var showingAddSession = false
    @State private var showingAddStudent = false
    
    var body: some View {
        List {
            Section(header: Text("Course Information")) {
                TextField("Dive Shop", text: Binding(
                    get: { course.diveShop?.name ?? "" },
                    set: { course.diveShop = DiveShop(name: $0, location: "") }
                ))
                Picker("Certification Agency", selection: Binding(
                    get: { course.certificationAgency ?? .padi },
                    set: { course.certificationAgency = $0 }
                )) {
                    ForEach(CertificationAgency.allCases) { agency in
                        Text(agency.displayName).tag(agency)
                    }
                }
                Picker("Course", selection: Binding(
                    get: { course.courseName },
                    set: { course.courseName = $0 }
                )) {
                    if let agency = course.certificationAgency {
                        ForEach(agency.getCourses(), id: \.self) { course in
                            Text(course).tag(course)
                        }
                    }
                }
                DatePicker("Start Date", selection: $course.startDate, displayedComponents: .date)
                DatePicker("End Date", selection: $course.endDate, displayedComponents: .date)
                Toggle("Completed", isOn: $course.isCompleted)
            }
            
            Section(header: Text("Students")) {
                ForEach(course.students) { student in
                    Text(student.firstName)
                }
                .onDelete(perform: deleteStudent)
                
                Button(action: { showingAddStudent = true }) {
                    Label("Add Student", systemImage: "person.badge.plus")
                }
            }
            
            Section(header: Text("Sessions")) {
                ForEach(course.sessions) { session in
                    VStack(alignment: .leading) {
                        Text("Session at \(session.location) on \(session.date, formatter: dateFormatter)")
                        Text("Type: \(session.type.rawValue)")
                        Text("Duration: \(session.duration) minutes")
                        if !session.notes.isEmpty {
                            Text("Notes: \(session.notes)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteSession)
                
                Button(action: { showingAddSession = true }) {
                    Label("Add Session", systemImage: "calendar.badge.plus")
                }
            }
        }
        .navigationTitle(course.courseName)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: saveCourse) {
                    Text("Save")
                }
            }
        }
        .sheet(isPresented: $showingAddStudent) {
            AddStudentView(students: $course.students)
        }
        .sheet(isPresented: $showingAddSession) {
            AddSessionView(sessions: $course.sessions)
        }
    }
    
    func saveCourse() {
        // Save changes to the course (if needed)
    }
    
    func deleteStudent(at offsets: IndexSet) {
        course.students.remove(atOffsets: offsets)
    }
    
    func deleteSession(at offsets: IndexSet) {
        course.sessions.remove(atOffsets: offsets)
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
}()

struct CourseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CourseDetailView(course: .constant(Course(students: [], sessions: [], diveShop: DiveShop(name: "Dive Shop A", location: ""), certificationAgency: .padi, courseName: "Open Water Diver", startDate: Date(), endDate: Date(), isCompleted: false)))
    }
}
