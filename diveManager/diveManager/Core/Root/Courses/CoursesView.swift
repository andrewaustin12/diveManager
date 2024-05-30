import SwiftUI
import EventKit

struct CoursesView: View {
    @EnvironmentObject var dataModel: DataModel
    @State private var showingAddCourse = false
    @State private var selectedFilter: CourseFilter = .inProgress
    
    var filteredCourses: [Course] {
        switch selectedFilter {
        case .upcoming:
            return dataModel.courses.filter { $0.startDate > Date() }
        case .inProgress:
            return dataModel.courses.filter { !$0.isCompleted && $0.startDate <= Date() && $0.endDate >= Date() }
        case .completed:
            return dataModel.courses.filter { $0.isCompleted }
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
                        .environmentObject(dataModel)
                }
            }
        }
    }
    
    func deleteCourse(at offsets: IndexSet) {
        dataModel.courses.remove(atOffsets: offsets)
    }
    
    private func formattedDateRange(start: Date, end: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }
    
    private func binding(for course: Course) -> Binding<Course> {
        guard let index = dataModel.courses.firstIndex(where: { $0.id == course.id }) else {
            fatalError("Course not found")
        }
        return $dataModel.courses[index]
    }
}

struct CoursesView_Previews: PreviewProvider {
    static var previews: some View {
        CoursesView()
            .environmentObject(DataModel())
    }
}
