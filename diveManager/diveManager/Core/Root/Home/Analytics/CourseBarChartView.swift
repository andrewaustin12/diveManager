import SwiftUI
import SwiftData
import Charts

struct CourseGroup: Hashable {
    let course: String
    let agency: String
}

struct CourseBarChartView: View {
    @Environment(\.modelContext) private var context // SwiftData context
    @Query private var courses: [Course] // Query to fetch courses from the data model

    var body: some View {
        // Group courses by their name and agency using CourseGroup struct
        let groupedCourses = Dictionary(grouping: courses, by: { CourseGroup(course: $0.selectedCourse, agency: $0.certificationAgency.displayName) })
        
        var chartData = groupedCourses.map { (key, value) in
            (courseGroup: key, count: value.count)
        }

        // Sort the chart data by count and take the top 5
        chartData.sort { $0.count > $1.count }
        let top5ChartData = Array(chartData.prefix(5))

        // Print the count of each course in the top 5
        for item in top5ChartData {
            print("\(item.courseGroup.course): \(item.count)")
        }

        let mostPopularCourse = top5ChartData.first

        return VStack(alignment: .leading, spacing: 4) {
            if let mostPopularCourse = mostPopularCourse {
                Text("Most Popular Course: ")
                    .font(.headline)
                
                Text(mostPopularCourse.courseGroup.agency + " " + mostPopularCourse.courseGroup.course)
                    .fontWeight(.semibold)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            
            Chart {
                ForEach(top5ChartData, id: \.courseGroup) { item in
                    BarMark(
                        x: .value("Count", item.count),
                        y: .value("Course", item.courseGroup.course)
                    )
                    .foregroundStyle(Color.teal.gradient)
                }
                .cornerRadius(6)
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks(preset: .aligned, values: .stride(by: 1)) {
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel()
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Course.self, configurations: config)

    return CourseBarChartView()
        .modelContainer(container)
}
