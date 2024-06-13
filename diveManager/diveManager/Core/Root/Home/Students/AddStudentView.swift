import SwiftUI

struct AddStudentView: View {
    @Binding var students: [Student]
    @Environment(\.presentationMode) var presentationMode
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var studentID: String = ""
    @State private var email: String = ""
    @State private var certifications: [Certification] = []
    @State private var selectedAgencies: [UUID: CertificationAgency] = [:]  // State to hold selected agency for each certification
    @State private var selectedExistingStudent: Student? = nil
    @State private var showExistingStudentPicker = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Student Information")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Student ID", text: $studentID)
                    TextField("Email", text: $email)
                    
                    Button(action: {
                        showExistingStudentPicker = true
                    }) {
                        Label("Add Existing Student", systemImage: "person.2.fill")
                    }
                }

                Section(header: Text("Certifications")) {
                    ForEach($certifications) { $certification in
                        VStack(alignment: .leading) {
                            let certId = certification.id
                            let selectedAgency = selectedAgencies[certId] ?? certification.agency

                            // Agency Picker
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

                            // Course Picker
                            Picker("Course", selection: $certification.name) {
                                ForEach(selectedAgencies[certId]?.getCourses() ?? [], id: \.self) { course in
                                    Text(course).tag(course)
                                }
                            }

                            // Date Picker
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
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .sheet(isPresented: $showExistingStudentPicker) {
                ExistingStudentPickerView(students: MockData.students, selectedStudent: $selectedExistingStudent) { student in
                    addExistingStudent(student)
                }
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
        students.append(newStudent)
        presentationMode.wrappedValue.dismiss()
    }

    func addExistingStudent(_ student: Student) {
        students.append(student)
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddStudentView_Previews: PreviewProvider {
    static var previews: some View {
        AddStudentView(students: .constant(MockData.students))
            .environmentObject(DataModel())
    }
}
