import SwiftUI
import SwiftData

struct AddNewStudentView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var studentID: String = ""
    @State private var email: String = ""
    @State private var certifications: [Certification] = []
    @State private var selectedAgencies: [UUID: CertificationAgency] = [:]
    @State private var selectedExistingStudent: Student?
    @State private var showExistingStudentPicker = false
    @Binding var selectedStudents: [Student]
    @Query private var existingStudents: [Student]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Student Information")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Student ID", text: $studentID)
                    TextField("Email", text: $email)
                }

                Section(header: Text("Certifications")) {
                    ForEach($certifications) { $certification in
                        VStack(alignment: .leading) {
                            let certId = certification.id
                            let selectedAgency = selectedAgencies[certId] ?? certification.agency

                            Picker("Agency", selection: Binding(
                                get: { selectedAgency },
                                set: { newValue in
                                    selectedAgencies[certId] = newValue
                                    certification.agency = newValue
                                    certification.name = newValue.getCourses().first ?? ""
                                }
                            )) {
                                ForEach(CertificationAgency.allCases) { agency in
                                    Text(agency.displayName).tag(agency)
                                }
                            }

                            Picker("Course", selection: $certification.name) {
                                ForEach(selectedAgencies[certId]?.getCourses() ?? [], id: \.self) { course in
                                    Text(course).tag(course)
                                }
                            }

                            DatePicker("Date Issued", selection: $certification.dateIssued, displayedComponents: .date)
                        }
                    }
                    .onDelete { indices in
                        certifications.remove(atOffsets: indices)
                    }

                    Button(action: addCertification) {
                        Label("Add Certification", systemImage: "plus")
                    }
                }

                Button(action: addStudent) {
                    Text("Add Student")
                }
                .disabled(firstName.isEmpty || lastName.isEmpty || studentID.isEmpty || email.isEmpty)
            }
            .navigationTitle("Add Student")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showExistingStudentPicker) {
                ExistingStudentPickerView(
                    students: existingStudents,
                    selectedStudent: $selectedExistingStudent,
                    onStudentSelected: { student in
                        selectedStudents.append(student)
                        dismiss()
                    }
                )
            }
        }
    }

    func addCertification() {
        let newCertification = Certification(name: CertificationAgency.padi.getCourses().first ?? "", dateIssued: Date(), agency: .padi)
        certifications.append(newCertification)
        selectedAgencies[newCertification.id] = .padi
    }

    func addStudent() {
        let newStudent = Student(firstName: firstName, lastName: lastName, studentID: studentID, email: email, certifications: certifications)
        context.insert(newStudent)
        selectedStudents.append(newStudent)
        dismiss()
    }
}

struct AddNewStudentView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Student.self, Certification.self, configurations: config)
        
        AddNewStudentView(selectedStudents: .constant([]))
            .modelContainer(container)
    }
}
