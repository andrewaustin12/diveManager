import SwiftUI
import SwiftData

struct AddCertificationView: View {
    @Bindable var student: Student
    @Environment(\.modelContext) private var context
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var dateIssued: Date = Date()
    @State private var selectedAgency: CertificationAgency = .padi
    @State private var selectedCourse: String = CertificationAgency.PADI.openWater.rawValue

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Certification Information")) {
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
                    DatePicker("Date Issued", selection: $dateIssued, displayedComponents: .date)
                }
                Button(action: addCertification) {
                    Text("Add Certification")
                }
            }
            .navigationTitle("Add Certification")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }

    func addCertification() {
        let newCertification = Certification(name: selectedCourse, dateIssued: dateIssued, agency: selectedAgency)
        student.certifications.append(newCertification)
        do {
            try context.save()
        } catch {
            print("Failed to save certification: \(error)")
        }
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddCertificationView_Previews: PreviewProvider {
    static var student = Student(
        firstName: "John",
        lastName: "Doe",
        studentID: "123-456-7890",
        email: "john@example.com",
        certifications: []
    )

    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Student.self, Certification.self, configurations: config)

        return AddCertificationView(student: student)
            .modelContainer(container)
    }
}
