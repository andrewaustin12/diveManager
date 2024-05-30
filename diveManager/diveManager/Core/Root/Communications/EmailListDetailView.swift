import SwiftUI
import MessageUI

struct EmailListDetailView: View {
    @EnvironmentObject var dataModel: DataModel
    @State var emailList: EmailList
    @State private var showingMailCompose = false
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil
    @State private var showingEditEmailListView = false

    var body: some View {
        VStack {
            List {
                ForEach(emailList.students) { student in
                    Text("\(student.firstName) \(student.lastName)")
                }
            }

            HStack {
                Button(action: {
                    showingMailCompose = true
                }) {
                    Text("Email List")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showingMailCompose) {
                    if MFMailComposeViewController.canSendMail() {
                        MailComposeView(
                            result: $mailResult,
                            subject: "Custom Email List",
                            recipients: emailList.students.map { $0.email },
                            messageBody: "Dear Students,\n\nHere is an important update.\n\nBest regards,\nYour Dive Manager"
                        )
                    } else {
                        Text("Mail services are not available")
                    }
                }
                Spacer()
                Button(action: {
                    showingEditEmailListView = true
                }) {
                    Text("Edit List")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showingEditEmailListView) {
                    EditEmailListView(emailList: emailList)
                        .environmentObject(dataModel)
                }
            }
            .padding()
        }
        .navigationTitle(emailList.name)
    }
}

struct EmailListDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EmailListDetailView(emailList: EmailList(name: "Sample List", students: MockData.students))
            .environmentObject(DataModel())
    }
}
