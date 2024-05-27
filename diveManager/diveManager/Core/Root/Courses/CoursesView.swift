import SwiftUI

struct CoursesView: View {
    @State private var courses: [Course] = [
        Course(
            students: [],
            sessions: [],
            diveShop: DiveShop(name: "Dive Shop A", location: ""),
            certificationAgency: .padi,
            courseName: CertificationAgency.PADI.openWater.rawValue,
            startDate: Date(),
            endDate: Calendar.current.date(byAdding: .day, value: 7, to: Date())!,
            isCompleted: false
        )
    ]
    @State private var showingAddCourse = false
    @State private var selectedCourse: Course?
    @State private var selectedFilter: CourseFilter = .inProgress
    
    var filteredCourses: [Course] {
        switch selectedFilter {
        case .notStarted:
            return courses.filter { $0.startDate > Date() }
        case .inProgress:
            return courses.filter { !$0.isCompleted && $0.startDate <= Date() && $0.endDate >= Date() }
        case .completed:
            return courses.filter { $0.isCompleted }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                
                
                List {
                    Picker("Filter", selection: $selectedFilter) {
                        ForEach(CourseFilter.allCases) { filter in
                            Text(filter.rawValue).tag(filter)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    ForEach(filteredCourses) { course in
                        NavigationLink(destination: CourseDetailView(course: binding(for: course))) {
                            VStack(alignment: .leading) {
                                Text(course.courseName)
                                    .font(.headline)
                                if let diveShop = course.diveShop {
                                    Text("Dive Shop: \(diveShop.name)")
                                        .font(.subheadline)
                                }
                                Text("Course Dates: \(formattedDateRange(start: course.startDate, end: course.endDate))")
                                    .font(.subheadline)
                            }
                        }
                    }
                    .onDelete(perform: deleteCourse)
                }
                .navigationTitle("Courses")
                .toolbar {
                    Button(action: { showingAddCourse = true }) {
                        Label("Add Course", systemImage: "plus")
                    }
                }
                .sheet(isPresented: $showingAddCourse) {
                    AddCourseView(courses: $courses)
                }
            }
        }
    }
    
    func deleteCourse(at offsets: IndexSet) {
        courses.remove(atOffsets: offsets)
    }
    
    private func formattedDateRange(start: Date, end: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yy"
        return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }
    
    private func binding(for course: Course) -> Binding<Course> {
        guard let index = courses.firstIndex(where: { $0.id == course.id }) else {
            fatalError("Course not found")
        }
        return $courses[index]
    }
}

struct CoursesView_Previews: PreviewProvider {
    static var previews: some View {
        CoursesView()
    }
}
