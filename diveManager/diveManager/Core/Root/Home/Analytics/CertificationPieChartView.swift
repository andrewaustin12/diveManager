import SwiftUI
import Charts

struct CertificationPieChartView: View {
    @EnvironmentObject private var dataModel: DataModel

    var body: some View {
        let certifications = dataModel.students.flatMap { $0.certifications }
        let groupedCertifications = Dictionary(grouping: certifications, by: { $0.agency })
        let chartData = groupedCertifications.map { (key, value) in
            (key.displayName, value.count)
        }

        // Find the most popular agency
        let mostPopularAgency = chartData.max(by: { $0.1 < $1.1 })

        return VStack(alignment: .leading) {
            if let mostPopularAgency = mostPopularAgency {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Most Popular Agency: ")
                        .font(.headline)
                    Text("\(mostPopularAgency.0) with \(mostPopularAgency.1) certifications")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            Chart {
                ForEach(chartData, id: \.0) { item in
                    SectorMark(
                        angle: .value("Count", item.1),
                        innerRadius: .ratio(0.5),
                        angularInset: 2
                    )
                    .foregroundStyle(by: .value("Agency", item.0))
                    .cornerRadius(6)
                }
            }
            .frame(height: 200)
            .chartLegend(position: .bottom) // Move the legend to the bottom
        }
    }
}

struct CertificationPieChartView_Previews: PreviewProvider {
    static var previews: some View {
        CertificationPieChartView()
            .environmentObject(DataModel())
            .frame(height: 300)
    }
}
