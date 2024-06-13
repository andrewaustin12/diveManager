import Foundation
import EventKit

class EventManager {
    static let shared = EventManager()
    private let eventStore = EKEventStore()

    private init() {}

    func getEventStore() -> EKEventStore {
        return eventStore
    }

    func requestCalendarAccess(completion: @escaping (Bool, Error?) -> Void) {
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents { granted, error in
                completion(granted, error)
            }
        } else {
            eventStore.requestAccess(to: .event) { granted, error in
                completion(granted, error)
            }
        }
    }
}
