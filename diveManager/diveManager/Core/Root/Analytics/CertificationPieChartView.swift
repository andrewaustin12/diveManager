import SwiftUI
import Charts

struct CertificationPieChartView: View {
    var certifications: [Certification]

    var body: some View {
        let groupedCertifications = Dictionary(grouping: certifications, by: { $0.agency })
        let chartData = groupedCertifications.map { (key, value) in
            (key.displayName, value.count)
        }

        return Chart {
            ForEach(chartData, id: \.0) { item in
                SectorMark(
                    angle: .value("Count", item.1),
                    innerRadius: .ratio(0.5)
                )
                .foregroundStyle(by: .value("Agency", item.0))
            }
        }
        .frame(height: 300)
    }
}

#Preview {
    CertificationPieChartView(certifications: MockData.students.flatMap { $0.certifications })
        .frame(height: 300)
}
