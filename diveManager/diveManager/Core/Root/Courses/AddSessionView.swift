import SwiftUI

struct AddSessionView: View {
    @Binding var sessions: [Session]
    @State private var date = Date()
    @State private var startTime = Date()
    @State private var endTime = Date().addingTimeInterval(3600)
    @State private var location: String = ""
    @State private var type: SessionType = .confinedWater
    @State private var duration: String = ""
    @State private var notes: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Session Information")) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    TextField("Location", text: $location)
                    Picker("Type", selection: $type) {
                        ForEach(SessionType.allCases) { sessionType in
                            Text(sessionType.displayName).tag(sessionType)
                        }
                    }
                    TextField("Duration (hours)", text: $duration)
                        .keyboardType(.numberPad)
                    TextField("Notes", text: $notes)
                }
                
                Button(action: addSession) {
                    Text("Add Session")
                }
            }
            .navigationTitle("Add Session")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    func addSession() {
        guard Int(duration) != nil else { return }
        let newSession = Session(date: date, startTime: startTime, endTime: endTime, location: location, type: type, duration: 120, notes: notes)
        sessions.append(newSession)
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddSessionView_Previews: PreviewProvider {
    static var previews: some View {
        AddSessionView(sessions: .constant([]))
    }
}
