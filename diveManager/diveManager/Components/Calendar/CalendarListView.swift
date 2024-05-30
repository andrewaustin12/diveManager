import SwiftUI
import EventKit

struct CalendarListView: View {
    @Binding var events: [EKEvent]

    var body: some View {
        List(events, id: \.eventIdentifier) { event in
            VStack(alignment: .leading) {
                Text(event.title)
                    .font(.headline)
                Text("\(event.startDate, formatter: dateFormatter) - \(event.endDate, formatter: dateFormatter)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()


struct CalendarListView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarListView(events: .constant([]))
    }
}
