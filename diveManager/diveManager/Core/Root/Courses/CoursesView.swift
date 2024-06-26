import SwiftUI
import EventKit
import SwiftData

struct CoursesView: View {
    @Environment(\.modelContext) private var context
    @Query private var courses: [Course]
    @State private var showingAddCourse = false
    @State private var selectedFilter: CourseFilter = .inProgress
    
    var filteredCourses: [Course] {
        let now = Date()
        let calendar = Calendar.current
        
        switch selectedFilter {
        case .upcoming:
            return courses.filter { $0.startDate > now }
        case .inProgress:
            return courses.filter {
                !$0.isCompleted && (
                    calendar.isDateInToday($0.startDate) ||
                    calendar.isDateInToday($0.endDate) ||
                    ($0.startDate <= now && $0.endDate >= now)
                )
            }
        case .completed:
            return courses.filter { $0.isCompleted }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(CourseFilter.allCases) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                List {
                    ForEach(filteredCourses) { course in
                        NavigationLink(destination: CourseDetailView(course: binding(for: course))) {
                            VStack(alignment: .leading) {
                                Text(course.selectedCourse)
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
                .listStyle(.plain)
                .navigationTitle("Courses")
                .toolbar {
                    Button(action: { showingAddCourse = true }) {
                        Label("Add Course", systemImage: "plus")
                    }
                }
                .sheet(isPresented: $showingAddCourse) {
                    AddCourseView()
                        .environment(\.modelContext, context)
                }
            }
        }
    }
    
    func deleteCourse(at offsets: IndexSet) {
        for index in offsets {
                    let course = filteredCourses[index]
                    if let originalIndex = courses.firstIndex(where: { $0.id == course.id }) {
                        context.delete(courses[originalIndex])
                    }
                }
    }
    
    private func formattedDateRange(start: Date, end: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }
    
    private func binding(for course: Course) -> Binding<Course> {
        guard let index = courses.firstIndex(where: { $0.id == course.id }) else {
            fatalError("Course not found")
        }
        return .constant(courses[index])
    }
}

struct CoursesView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Course.self, configurations: config)
        
        CoursesView()
            .modelContainer(container)
    }
}
