import SwiftUI
import EventKit
import UIKit

struct CalendarView: UIViewRepresentable {
    @EnvironmentObject var dataModel: DataModel

    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        let gregorianCalendar = Calendar(identifier: .gregorian)

        calendarView.calendar = gregorianCalendar
        calendarView.locale = Locale(identifier: "en_US")
        calendarView.fontDesign = .rounded

        // Set the calendar to the current date
        let currentDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        calendarView.visibleDateComponents = currentDateComponents

        // Set the available date range
        if let fromDate = Calendar.current.date(byAdding: .year, value: -1, to: Date()),
           let toDate = Calendar.current.date(byAdding: .year, value: 1, to: Date()) {
            let calendarViewDateRange = DateInterval(start: fromDate, end: toDate)
            calendarView.availableDateRange = calendarViewDateRange
        }

        calendarView.delegate = context.coordinator

        return calendarView
    }

    func updateUIView(_ uiView: UICalendarView, context: Context) {
        context.coordinator.updateCourses(courses: dataModel.courses)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, UICalendarViewDelegate {
        var decorations: [Date: UICalendarView.Decoration] = [:]

        func updateCourses(courses: [Course]) {
            decorations.removeAll()

            let calendar = Calendar(identifier: .gregorian)
            for course in courses {
                guard let startDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: course.startDate)),
                      let endDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: course.endDate)) else { continue }
                
                var currentDate = startDate

                while currentDate <= endDate {
                    decorations[currentDate] = UICalendarView.Decoration.default(color: .blue, size: .large)
                    if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                        currentDate = nextDate
                    } else {
                        break
                    }
                }
            }
        }

        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            guard let date = dateComponents.date else { return nil }
            return decorations[date]
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .environmentObject(DataModel())
    }
}
