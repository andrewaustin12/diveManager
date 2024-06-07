import SwiftUI

enum ScheduleFilter: String, CaseIterable, Identifiable {
    case today = "Today"
    case thisWeek = "This Week"
    case thisMonth = "This Month"

    var id: String { self.rawValue }
}

struct ScheduleView: View {
    @EnvironmentObject var dataModel: DataModel
    @State private var showingAddCourseView = false
    @State private var selectedFilter: ScheduleFilter = .today

    var filteredCourses: [Course] {
        let now = Date()
        let calendar = Calendar.current

        switch selectedFilter {
        case .today:
            return dataModel.courses.filter {
                $0.startDate <= now && $0.endDate >= now
            }
        case .thisWeek:
            let endOfWeek = calendar.date(byAdding: .day, value: 7, to: now)!
            return dataModel.courses.filter {
                $0.startDate >= now && $0.startDate <= endOfWeek
            }
        case .thisMonth:
            let endOfMonth = calendar.date(byAdding: .day, value: 30, to: now)!
            return dataModel.courses.filter {
                $0.startDate >= now && $0.startDate <= endOfMonth
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(ScheduleFilter.allCases) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .onChange(of: selectedFilter) { newValue in
                    print("Selected Filter: \(newValue.rawValue)")
                }

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
                    //.onDelete(perform: deleteCourse)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Schedule Management")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: { showingAddCourseView = true }) {
//                        Label("Add Course", systemImage: "plus")
//                    }
//                }
//            }
            .sheet(isPresented: $showingAddCourseView) {
                AddCourseView(courses: $dataModel.courses)
                    .environmentObject(dataModel)
            }
        }
    }

    private func deleteCourse(at offsets: IndexSet) {
        dataModel.courses.remove(atOffsets: offsets)
    }

    private func formattedDateRange(start: Date, end: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
            .environmentObject(DataModel())
    }
}
