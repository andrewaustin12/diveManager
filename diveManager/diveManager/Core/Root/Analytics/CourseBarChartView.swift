import SwiftUI
import Charts

struct CourseBarChartView: View {
    var courses: [Course]

    var body: some View {
        let groupedCourses = Dictionary(grouping: courses, by: { $0.selectedCourse })
        let chartData = groupedCourses.map { (key, value) in
            (key, value.count)
        }

        return Chart {
            ForEach(chartData, id: \.0) { item in
                BarMark(
                    x: .value("Course", item.0),
                    y: .value("Count", item.1)
                )
                .foregroundStyle(Color.blue)
            }
        }
    }
}


#Preview {
    CourseBarChartView(courses: MockData.courses)
                .frame(height: 300)
}
