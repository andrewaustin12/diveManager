import SwiftUI

struct CommunicationsView: View {
    @State private var showingEmailStudentsView = false
    @State private var showingEmailListsView = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    CommunicationsSectionView(
                        title: "Email Students by Course",
                        systemImage: "person.3",
                        description: "Group email your students",
                        destination: EmailStudentsByCourseView()
                    )
                    CommunicationsSectionView(
                        title: "Email Lists",
                        systemImage: "list.bullet",
                        description: "Create and manaage email lists",
                        destination: EmailListsView()
                    )
                }
                .padding()
//                GroupBox(label: Label("Email Students by Course", systemImage: "person.3")) {
//                    NavigationLink(destination: EmailStudentsByCourseView()) {
//                        Text("Email Students by Course")
//                    }
//                }
//                .padding(.horizontal)
//                
//
//                GroupBox(label: Label("Manage Email Lists", systemImage: "list.bullet")) {
//                    NavigationLink(destination: EmailListsView()) {
//                        Text("Manage Email Lists")
//                    }
//                }
//                .padding(.horizontal)
            }
            .navigationTitle("Communications")
        }
    }
}

struct CommunicationsView_Previews: PreviewProvider {
    static var previews: some View {
        CommunicationsView()
            .environmentObject(DataModel())
    }
}

struct CommunicationsSectionView<Destination: View>: View {
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
