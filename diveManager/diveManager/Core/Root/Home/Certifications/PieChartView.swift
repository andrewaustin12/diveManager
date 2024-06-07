import SwiftUI
import Charts

struct PieChartView: View {
    var data: [CertificationAgency: Int]

    var body: some View {
        Chart(data.sorted(by: { $0.key.rawValue < $1.key.rawValue }), id: \.key) { key, value in
            SectorMark(
                angle: .value("Certifications", value),
                innerRadius: .ratio(0.5),
                outerRadius: .ratio(1)
            )
            .foregroundStyle(by: .value("Agency", key.displayName))
        }
    }
}
