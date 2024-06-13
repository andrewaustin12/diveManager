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
        }
        .navigationTitle(emailList.name)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    showingMailCompose = true
                }) {
                    Image(systemName: "envelope")
                        
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
                
                Button(action: {
                    showingEditEmailListView = true
                }) {
                    Image(systemName: "pencil")
                        
                }
                .sheet(isPresented: $showingEditEmailListView) {
                    EditEmailListView(emailList: emailList)
                        .environmentObject(dataModel)
                }
            }
        }
    }
}

struct EmailListDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EmailListDetailView(emailList: EmailList(name: "Sample List", students: MockData.students))
                .environmentObject(DataModel())
        }
    }
}
