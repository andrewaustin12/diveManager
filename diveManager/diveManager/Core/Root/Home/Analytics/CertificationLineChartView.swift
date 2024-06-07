import SwiftUI
import Charts

struct CertificationLineChartView: View {
    var certifications: [Certification]

    var body: some View {
        let groupedCertifications = Dictionary(grouping: certifications, by: { Calendar.current.startOfDay(for: $0.dateIssued) })
        let chartData = groupedCertifications.map { (key, value) in
            (key, value.count)
        }.sorted { $0.0 < $1.0 }

        return Chart {
            ForEach(chartData, id: \.0) { item in
                LineMark(
                    x: .value("Date", item.0),
                    y: .value("Count", item.1)
                )
                .foregroundStyle(Color.purple)
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 10)) { value in
                AxisGridLine()
                AxisValueLabel(format: .dateTime.year().month().day())
            }
        }
        .chartYAxis {
            AxisMarks()
        }
    }
}

#Preview {
    CertificationLineChartView(certifications: MockData.students.flatMap { $0.certifications })
                .frame(height: 300)
}
