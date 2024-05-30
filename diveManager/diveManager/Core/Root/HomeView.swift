import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {  // Add spacing between GroupBoxes
                    
//                    HomeSectionView(
//                        title: "Course Management",
//                        systemImage: "book",
//                        description: "Create, manage, and track courses.",
//                        destination: CoursesView()
//                    )
                    
                    HomeSectionView(
                        title: "Student Management",
                        systemImage: "person.2",
                        description: "Manage students and track progress.",
                        destination: StudentsView()
                    )
                    
                    HomeSectionView(
                        title: "Invoice Management",
                        systemImage: "doc.text",
                        description: "Create and manage invoices.",
                        destination: InvoiceManagementView()
                    )
                    
                    HomeSectionView(
                        title: "Certification Tracking",
                        systemImage: "graduationcap",
                        description: "Track and record certifications.",
                        destination: CertificationsView()
                    )
                    
                    HomeSectionView(
                        title: "Dive Shops",
                        systemImage: "house.lodge",
                        description: "Manage dive shops and locations.",
                        destination: DiveShopsView()
                    )
                    
//                    HomeSectionView(
//                        title: "Financial Management",
//                        systemImage: "dollarsign.circle",
//                        description: "Track income and expenses.",
//                        destination: FinancialView()
//                    )
                    
                    HomeSectionView(
                        title: "Communication Tools",
                        systemImage: "envelope",
                        description: "Send messages and notifications.",
                        destination: CommunicationsView()
                    )
                    
                    HomeSectionView(
                        title: "Analytics and Reporting",
                        systemImage: "chart.bar",
                        description: "Track performance and generate reports.",
                        destination: AnalyticsView()
                    )
                    
                }
                .padding()
            }
            .navigationTitle("Dashboard")
        }
    }
}

struct HomeSectionView<Destination: View>: View {
    let title: String
    let systemImage: String
    let description: String
    let destination: Destination
    
    var body: some View {
        GeometryReader { geometry in
            NavigationLink(destination: destination) {
                GroupBox {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: systemImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.blue)
                            Spacer()
                        }
                        Text(title)
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(height: 80)
                }
                .groupBoxStyle(DefaultGroupBoxStyle())
            }
            .buttonStyle(PlainButtonStyle())
            .frame(width: geometry.size.width, height: 100) // Fixed height
            .padding(.bottom, 10)  // Add bottom padding for spacing
        }
        .frame(height: 100) // Fixed height
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(DataModel())
    }
}
