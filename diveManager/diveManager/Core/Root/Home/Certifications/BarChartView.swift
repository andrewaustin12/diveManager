import SwiftUI
import Charts

struct BarChartView: View {
    var data: [CertificationAgency: Int]

    var body: some View {
        Chart(data.sorted(by: { $0.key.rawValue < $1.key.rawValue }), id: \.key) { key, value in
            BarMark(
                x: .value("Agency", key.displayName),
                y: .value("Certifications", value)
            )
        }
        .chartXAxis {
            AxisMarks(values: .automatic) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
            }
        }
        .chartYAxis {
            AxisMarks(values: .automatic) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
            }
        }
    }
}

