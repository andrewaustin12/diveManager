import SwiftUI
import MessageUI

struct EmailStudentsByCourseView: View {
    @EnvironmentObject var dataModel: DataModel
    @State private var selectedCourse: Course?
    @State private var showingMailCompose = false
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil
    @State private var selectedStudents: [UUID: Bool] = [:]
    @State private var searchText: String = ""

    var filteredCourses: [Course] {
        if searchText.isEmpty {
            return dataModel.courses
        } else {
            return dataModel.courses.filter { $0.selectedCourse.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section(header: Text("Select a Course")) {
                        ForEach(filteredCourses) { course in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(course.selectedCourse)
                                        .font(.headline)
                                    Text("Start Date: \(formattedDate(course.startDate))")
                                        .font(.subheadline)
                                    Text("End Date: \(formattedDate(course.endDate))")
                                        .font(.subheadline)
                                }
                                Spacer()
                                if selectedCourse?.id == course.id {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                toggleCourseSelection(course)
                            }
                        }
                    }
                }
                .searchable(text: $searchText)
                .navigationTitle("Email Students")

                if let course = selectedCourse {
                    VStack {
                        List {
                            Section(header: Text("Select Students to Email")) {
                                ForEach(course.students) { student in
                                    Toggle("\(student.firstName) \(student.lastName)", isOn: Binding(
                                        get: { self.selectedStudents[student.id] ?? true },
                                        set: { self.selectedStudents[student.id] = $0 }
                                    ))
                                }
                            }
                        }

                        Button(action: sendEmailToCourseStudents) {
                            Text("Email Selected Students")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                }
            }
            .sheet(isPresented: $showingMailCompose) {
                if MFMailComposeViewController.canSendMail(), let course = selectedCourse {
                    let recipients = course.students.filter { selectedStudents[$0.id] ?? true }.map { $0.email }
                    MailComposeView(
                        result: $mailResult,
                        subject: "Course Update",
                        recipients: recipients,
                        messageBody: "Dear Students,\n\nHere is an update regarding your course.\n\nBest regards,\nYour Dive Manager"
                    )
                } else {
                    Text("Mail services are not available")
                }
            }
        }
    }

    private func toggleCourseSelection(_ course: Course) {
        if selectedCourse?.id == course.id {
            selectedCourse = nil
            selectedStudents = [:]
        } else {
            selectedCourse = course
            selectedStudents = Dictionary(uniqueKeysWithValues: course.students.map { ($0.id, true) })
        }
    }

    private func sendEmailToCourseStudents() {
        showingMailCompose = true
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct EmailStudentsByCourseView_Previews: PreviewProvider {
    static var previews: some View {
        EmailStudentsByCourseView()
            .environmentObject(DataModel())
    }
}
