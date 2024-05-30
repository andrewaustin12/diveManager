import SwiftUI

struct ScheduleView: View {
    @EnvironmentObject var dataModel: DataModel
    @State private var showingAddCourseView = false
    @State private var selectedFilter: CourseFilter = .upcoming

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
                        VStack(alignment: .leading) {
                            Text(course.selectedCourse)
                                .font(.headline)
                            if let diveShop = course.diveShop {
                                Text("Dive Shop: \(diveShop.name)")
                                    .font(.subheadline)
                            }
                            Text("Course Dates: \(formattedDateRange(start: course.startDate, end: course.endDate))")
                                .font(.subheadline)
                            Text("Students: \(course.students.count)")
                                .font(.subheadline)
                        }
                    }
                    .onDelete(perform: deleteCourse)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Schedule Management")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddCourseView = true }) {
                        Label("Add Course", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddCourseView) {
                AddCourseView()
                    .environmentObject(dataModel)
            }
        }
    }

    private func deleteCourse(at offsets: IndexSet) {
        dataModel.courses.remove(atOffsets: offsets)
    }

    private func formattedDateRange(start: Date, end: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yy"
        return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
            .environmentObject(DataModel())
    }
}
