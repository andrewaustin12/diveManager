import SwiftUI
import Charts

struct CourseGroup: Hashable {
    let course: String
    let agency: String
}

struct CourseBarChartView: View {
    @EnvironmentObject var dataModel: DataModel

    var body: some View {
        // Group courses by their name and agency using CourseGroup struct
        let groupedCourses = Dictionary(grouping: dataModel.courses, by: { CourseGroup(course: $0.selectedCourse, agency: $0.certificationAgency.displayName) })
        
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
                    .padding(.bottom, 12)
            }
            
            Chart {
                ForEach(top5ChartData, id: \.courseGroup) { item in
                    BarMark(
                        x: .value("Course", item.courseGroup.course),
                        y: .value("Count", item.count)
                    )
                    .foregroundStyle(Color.blue)
                }
            }
            .frame(height: 200)
        }
    }
}

struct CourseBarChartView_Previews: PreviewProvider {
    static var previews: some View {
        CourseBarChartView()
            .environmentObject(DataModel()) // Providing a sample DataModel for preview
            .frame(height: 300)
    }
}
