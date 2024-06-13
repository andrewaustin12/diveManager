import SwiftUI

struct CourseDetailView: View {
    @Binding var course: Course
    @EnvironmentObject var dataModel: DataModel
    @State private var showingAddSession = false
    @State private var showingAddStudent = false
    @State private var showingAddCourseToInvoice = false
    @State private var isEditing = false

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
                .disabled(!isEditing)

                Picker("Course", selection: $course.selectedCourse) {
                    ForEach(course.certificationAgency.getCourses(), id: \.self) { course in
                        Text(course).tag(course)
                    }
                }
                .disabled(!isEditing)
                
                DatePicker("Start Date", selection: $course.startDate, displayedComponents: .date)
                    .disabled(!isEditing)
                
                DatePicker("End Date", selection: $course.endDate, displayedComponents: .date)
                    .disabled(!isEditing)
                
                Toggle("Completed", isOn: $course.isCompleted)
                    .disabled(!isEditing)
                
                if isEditing {
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
            }

            Section(header: Text("Students")) {
                ForEach(course.students) { student in
                    Text("\(student.firstName) \(student.lastName)")
                }
                .onDelete(perform: isEditing ? deleteStudent : nil)

                if isEditing {
                    Button(action: { showingAddStudent = true }) {
                        Label("Add Student", systemImage: "person.badge.plus")
                    }
                }
            }

            Section(header: Text("Sessions")) {
                ForEach(course.sessions) { session in
                    VStack(alignment: .leading) {
                        Text("Session at \(session.location) on \(session.date, formatter: dateFormatter)")
                        Text("Type: \(session.type.displayName)")
                        Text("Duration: \(session.duration) minutes")
                        if !session.notes.isEmpty {
                            Text("Notes: \(session.notes)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: isEditing ? deleteSession : nil)

                if isEditing {
                    Button(action: { showingAddSession = true }) {
                        Label("Add Session", systemImage: "calendar.badge.plus")
                    }
                }
            }
        }
        .navigationTitle(course.selectedCourse)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: toggleEditing) {
                    Text(isEditing ? "Save" : "Edit")
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

    private func toggleEditing() {
        if isEditing {
            saveCourse()
        }
        isEditing.toggle()
    }

    private func saveCourse() {
        if let index = dataModel.courses.firstIndex(where: { $0.id == course.id }) {
                    dataModel.courses[index] = course
                }
    }

    private func deleteStudent(at offsets: IndexSet) {
        course.students.remove(atOffsets: offsets)
    }

    private func deleteSession(at offsets: IndexSet) {
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
        NavigationStack {
            CourseDetailView(course: .constant(MockData.courses[0]))
                .environmentObject(DataModel())
        }
    }
}
