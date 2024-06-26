import SwiftUI
import EventKitUI
import SwiftData

enum ScheduleFilter: String, CaseIterable, Identifiable {
    case today = "Today"
    case thisWeek = "This Week"
    case thisMonth = "This Month"

    var id: String { self.rawValue }
}

struct ScheduleView: View {
    @Environment(\.modelContext) private var context // Use the SwiftData model context environment
    @Query private var allCourses: [Course] // Use SwiftData query to fetch all courses
    @State private var showingAddCourseView = false
    @State private var selectedFilter: ScheduleFilter = .today
    @State private var showingEventEditView = false
    @State private var selectedCourse: Course?
    @State private var calendarAccessGranted = false

    // Filter courses based on the selected filter
    var filteredCourses: [Course] {
        let now = Date()
        let calendar = Calendar.current

        switch selectedFilter {
        case .today:
            // Filter courses happening today
            return allCourses.filter {
                calendar.isDateInToday($0.startDate) || calendar.isDateInToday($0.endDate)
            }
        case .thisWeek:
            // Filter courses happening within the next 7 days
            let startOfWeek = calendar.startOfDay(for: now)
            let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)!
            return allCourses.filter {
                ($0.startDate >= startOfWeek && $0.startDate <= endOfWeek) ||
                ($0.endDate >= startOfWeek && $0.endDate <= endOfWeek)
            }
        case .thisMonth:
            // Filter courses happening within the next 30 days
            let startOfMonth = calendar.startOfDay(for: now)
            let endOfMonth = calendar.date(byAdding: .day, value: 30, to: startOfMonth)!
            return allCourses.filter {
                ($0.startDate >= startOfMonth && $0.startDate <= endOfMonth) ||
                ($0.endDate >= startOfMonth && $0.endDate <= endOfMonth)
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                // Filter Picker to choose the schedule filter
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

                // List to display the filtered courses
                List {
                    ForEach(filteredCourses) { course in
                        HStack {
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
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Schedule")
            .sheet(isPresented: $showingEventEditView) {
                if let selectedCourse = selectedCourse {
                    EKEventEditView(eventStore: EventManager.shared.getEventStore(), course: selectedCourse)
                }
            }
        }
    }

    // Helper function to format date ranges
    private func formattedDateRange(start: Date, end: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Course.self, configurations: config)
        
        ScheduleView()
            .modelContainer(container) // Use model container for preview
    }
}
