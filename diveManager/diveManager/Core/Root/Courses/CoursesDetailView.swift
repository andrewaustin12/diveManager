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
                TextField("Certification Agency", text: Binding(
                    get: { course.certificationAgency?.name ?? "" },
                    set: { course.certificationAgency = CertificationAgency(name: $0, website: "") }
                ))
                //Toggle("Completed", isOn: $course.isCompleted)
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
        .navigationTitle(course.name)
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
        CourseDetailView(course: .constant(Course(name: "Freediving Basics", students: [], sessions: [], diveShop: DiveShop(name: "Dive Shop A", location: ""), certificationAgency: CertificationAgency(name: "PADI", website: ""), isCompleted: false)))
    }
}
