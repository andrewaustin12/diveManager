import SwiftUI
import Charts

struct CertificationsView: View {
    @State private var students: [Student] = MockData.students

    var certificationsByAgency: [CertificationAgency: Int] {
        var counts: [CertificationAgency: Int] = [:]
        for student in students {
            for cert in student.certifications {
                counts[cert.agency, default: 0] += 1
            }
        }
        return counts
    }

    var totalCertifications: Int {
        return students.flatMap { $0.certifications }.count
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Total Certifications
                    GroupBox(label: Text("Total Certifications")) {
                        Text("\(totalCertifications)")
                            .font(.largeTitle)
                            
                    }
                    .padding(.horizontal)

                    // Bar Chart
                    GroupBox(label: Text("Certifications by Agency")) {
                        BarChartView(data: certificationsByAgency)
                            .frame(height: 300)
                            .padding()
                    }
                    .padding(.horizontal)

                    // Pie Chart
                    GroupBox(label: Text("Certifications Distribution")) {
                        PieChartView(data: certificationsByAgency)
                            .frame(height: 300)
                            .padding()
                    }
                    .padding(.horizontal)
                }
                .navigationTitle("Certifications")
            }
        }
    }
}

struct CertificationsView_Previews: PreviewProvider {
    static var previews: some View {
        CertificationsView()
    }
}
