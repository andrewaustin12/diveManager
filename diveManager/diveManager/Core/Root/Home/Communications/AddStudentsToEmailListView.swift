import SwiftUI

enum StudentFilter: String, CaseIterable, Identifiable {
    case all = "All Students"
    case certification = "Certification"
    
    var id: String { self.rawValue }
}

struct AddStudentsToEmailListView: View {
    @EnvironmentObject var dataModel: DataModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedStudents: Set<UUID>
    @Binding var emailList: EmailList
    @State private var searchText = ""
    @State private var selectedFilter: StudentFilter = .all
    @State private var selectedCertification: Certification?

    var uniqueCertifications: [Certification] {
            let allCertifications = dataModel.students.flatMap { $0.certifications }
            let uniqueCertifications = Array(Set(allCertifications))
            return uniqueCertifications.sorted { $0.name < $1.name }
        }

    var filteredStudents: [Student] {
        let students: [Student]
        
        switch selectedFilter {
        case .all:
            students = dataModel.students
        case .certification:
            guard let certification = selectedCertification else { return [] }
            students = dataModel.students.filter { student in
                student.certifications.contains(certification)
            }
        }
        
        if searchText.isEmpty {
            return students
        } else {
            return students.filter { $0.firstName.contains(searchText) || $0.lastName.contains(searchText) }
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
                        Picker("Certification", selection: $selectedCertification) {
                            Text("Select Certification").tag(nil as Certification?)
                            ForEach(uniqueCertifications, id: \.self) { certification in
                                Text(certification.name).tag(certification as Certification?)
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
                                    if !emailList.students.contains(where: { $0.id == student.id }) {
                                        emailList.students.append(student)
                                    }
                                } else {
                                    self.selectedStudents.remove(student.id)
                                    emailList.students.removeAll { $0.id == student.id }
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
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
    }
}

struct AddStudentsToEmailListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddStudentsToEmailListView(selectedStudents: .constant(Set(MockData.students.map { $0.id })), emailList: .constant(EmailList(name: "Sample List", students: MockData.students)))
                .environmentObject(DataModel())
        }
    }
}
