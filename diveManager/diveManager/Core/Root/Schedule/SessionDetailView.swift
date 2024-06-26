import SwiftUI

struct SessionDetailView: View {
    var session: Session

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
//            HStack {
//                Text("Description:")
//                Spacer()
//                Text(session.description)
//                    .foregroundColor(.secondary)
//            }
            HStack {
                Text("Date:")
                Spacer()
                Text(formattedDate(session.date))
                    .foregroundColor(.secondary)
            }
            HStack {
                Text("Start Time:")
                Spacer()
                Text(formattedTime(session.startTime))
                    .foregroundColor(.secondary)
            }
            HStack {
                Text("End Time:")
                Spacer()
                Text(formattedTime(session.endTime))
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .navigationTitle("Session Detail")
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    private func formattedTime(_ time: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: time)
    }
}

struct SessionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SessionDetailView(session: MockData.sessions[0])
    }
}
