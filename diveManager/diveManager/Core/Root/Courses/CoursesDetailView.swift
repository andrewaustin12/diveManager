import SwiftUI

struct CourseDetailView: View {
    @Binding var course: Course
    @State private var showingAddSession = false
    @State private var showingAddStudent = false
    @State private var showingAddCourseToInvoice = false

    var body: some View {
        List {
            Section(header: Text("Course Information")) {
                TextField("Dive Shop", text: Binding(
                    get: { course.diveShop?.name ?? "" },
                    set: {
                        if course.diveShop == nil {
                            course.diveShop = DiveShop(name: $0, address: "", phone: "")
                        } else {
                            course.diveShop?.name = $0
                        }
                    }
                ))

                Picker("Course", selection: $course.selectedCourse) {
                    ForEach(course.certificationAgency.getCourses(), id: \.self) { course in
                        Text(course).tag(course)
                    }
                }
                DatePicker("Start Date", selection: $course.startDate, displayedComponents: .date)
                DatePicker("End Date", selection: $course.endDate, displayedComponents: .date)
                Toggle("Completed", isOn: $course.isCompleted)
                
                Button(action: {
                    showingAddCourseToInvoice = true
                }) {
                    HStack {
                        Spacer()
                        Text("Add Course to Invoice")
                            .font(.headline)
                            .foregroundColor(.blue)
                        Spacer()
                    }
                }
            }

            Section(header: Text("Students")) {
                ForEach(course.students) { student in
                    Text("\(student.firstName) \(student.lastName)")
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
        .navigationTitle(course.selectedCourse)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: saveCourse) {
                    Text("Save")
                }
            }
        }
        .sheet(isPresented: $showingAddStudent) {
            AddStudentView(students: $course.students)
                .environmentObject(DataModel())
        }
        .sheet(isPresented: $showingAddSession) {
            AddSessionView(sessions: $course.sessions)
                .environmentObject(DataModel())
        }
        .sheet(isPresented: $showingAddCourseToInvoice) {
            AddCourseToInvoiceView(course: $course)
                .environmentObject(DataModel())
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
        CourseDetailView(course: .constant(MockData.courses[0]))
            .environmentObject(DataModel())
    }
}
