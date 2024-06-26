import SwiftUI
import SwiftData

enum StudentFilter: String, CaseIterable, Identifiable {
    case all = "All Students"
    case certification = "Certification"
    
    var id: String { self.rawValue }
}

struct AddStudentsToEmailListView: View {
    @Environment(\.modelContext) private var context // Use the model context environment
    @Environment(\.dismiss) private var dismiss // Use the dismiss environment action
    @Binding var selectedStudents: Set<UUID> // Binding to track selected students by their UUID
    @State private var searchText = ""
    @State private var selectedFilter: StudentFilter = .all
    @State private var selectedCertificationName: String? = nil
    @Query private var students: [Student] // Use SwiftData query to fetch students

    // Get unique certification names from students
    var uniqueCertificationNames: [String] {
        let allCertificationNames = students.flatMap { $0.certifications.map { $0.name } }
        let uniqueCertificationNames = Array(Set(allCertificationNames))
        return uniqueCertificationNames.sorted()
    }

    // Filter students based on the selected filter and search text
    var filteredStudents: [Student] {
        var students: [Student]
        
        switch selectedFilter {
        case .all:
            students = self.students
        case .certification:
            guard let certificationName = selectedCertificationName else { return [] }
            students = self.students.filter { student in
                student.certifications.contains { $0.name == certificationName }
            }
        }
        
        if searchText.isEmpty {
            return students
        } else {
            return students.filter { $0.firstName.localizedCaseInsensitiveContains(searchText) || $0.lastName.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Filter Students")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    Picker("Filter", selection: $selectedFilter) {
                        ForEach(StudentFilter.allCases) { filter in
                            Text(filter.rawValue).tag(filter)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    if selectedFilter == .certification {
                        Picker("Certification", selection: $selectedCertificationName) {
                            Text("Select Certification").tag(nil as String?)
                            ForEach(uniqueCertificationNames, id: \.self) { certificationName in
                                Text(certificationName).tag(certificationName as String?)
                            }
                        }
                        .padding(.horizontal)
                        .pickerStyle(MenuPickerStyle())
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color(.secondarySystemBackground)))
                        .padding(.horizontal)
                    }
                }
                
                List {
                    ForEach(filteredStudents) { student in
                        Toggle(isOn: Binding(
                            get: { self.selectedStudents.contains(student.id) },
                            set: { newValue in
                                if newValue {
                                    self.selectedStudents.insert(student.id)
                                } else {
                                    self.selectedStudents.remove(student.id)
                                }
                            }
                        )) {
                            Text("\(student.firstName) \(student.lastName)")
                        }
                    }
                }
                .searchable(text: $searchText)
                .navigationTitle("Add Students")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

struct AddStudentsToEmailListView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: EmailList.self, Student.self, configurations: config)

        AddStudentsToEmailListView(selectedStudents: .constant(Set()))
            .modelContainer(container) // Use model container for preview
    }
}
