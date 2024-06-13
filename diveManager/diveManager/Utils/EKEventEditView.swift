import SwiftUI
import EventKit
import EventKitUI

struct EKEventEditView: UIViewControllerRepresentable {
    let eventStore: EKEventStore
    let course: Course

    func makeUIViewController(context: Context) -> EKEventEditViewController {
        let event = EKEvent(eventStore: eventStore)
        event.title = course.selectedCourse
        event.startDate = course.startDate
        event.endDate = course.endDate
        event.location = course.diveShop?.name

        let eventEditVC = EKEventEditViewController()
        eventEditVC.event = event
        eventEditVC.eventStore = eventStore
        eventEditVC.editViewDelegate = context.coordinator
        return eventEditVC
    }

    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, EKEventEditViewDelegate {
        var parent: EKEventEditView

        init(_ parent: EKEventEditView) {
            self.parent = parent
        }

        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            controller.dismiss(animated: true) {
                //self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
