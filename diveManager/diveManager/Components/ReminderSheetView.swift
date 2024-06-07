import SwiftUI

struct ReminderSheet: View {
    @Binding var notificationDate: Date
    var onSetReminder: (Date) -> Void

    var body: some View {
        VStack {
            DatePicker("Select Reminder Date", selection: $notificationDate, in: Date()...)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()

            Button(action: {
                onSetReminder(notificationDate)
            }) {
                Text("Set Reminder")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            Spacer()
        }
    }
}

struct ReminderSheet_Previews: PreviewProvider {
    @State static var date = Date()
    static var previews: some View {
        ReminderSheet(notificationDate: $date) { _ in }
    }
}
