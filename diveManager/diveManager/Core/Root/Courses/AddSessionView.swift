import SwiftUI

struct AddSessionView: View {
    @Binding var sessions: [Session]
    @State private var date = Date()
    @State private var location: String = ""
    @State private var type: SessionType = .pool
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
                            Text(sessionType.rawValue).tag(sessionType)
                        }
                    }
                    TextField("Duration (minutes)", text: $duration)
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
        guard let durationInt = Int(duration) else { return }
        let newSession = Session(date: date, location: location, type: type, duration: durationInt, notes: notes)
        sessions.append(newSession)
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddSessionView_Previews: PreviewProvider {
    static var previews: some View {
        AddSessionView(sessions: .constant([]))
    }
}
