
import SwiftUI
//import WishKit
//import RevenueCat
//import RevenueCatUI

struct SettingsView: View {
    
    var body: some View {
        NavigationStack {
            
            VStack {
                
                List {
                    
                    Section("Support"){
//                        NavigationLink(destination: WishKit.view) {
//                            Label("Feature Request", systemImage: "lightbulb.min")
//                        }
//                        
//                        NavigationLink(destination: BuyMeACoffeeView()) {
//                            Label("Buy me a coffee", systemImage: "mug.fill")
//                        }
                        
                        Label{
                            Text("Feedback")
                        } icon: {
                            Image(systemName: "envelope")
                        }
                        .onTapGesture {
                            sendEmail()
                        }
                        
                        Label {
                            HStack {
                                Text("Rate in the App Store")
                                Spacer() // This will push the text and icon to opposite ends
                                Image(systemName: "link") // The link icon
                                    .foregroundColor(.blue)
                            }
                        } icon: {
                            Image(systemName: "star.circle.fill")
                                .foregroundColor(Color.yellow)
                        }
                        .onTapGesture {
                            openAppStoreForRating()
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Settings")

        }
    }
}


#Preview {
    SettingsView()
}

func openAppStoreForRating() {
    guard let url = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID") else {
        return // Invalid URL
    }
    if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
    }
}

private func sendEmail() {
    let email = "andyaustin_dev@yahoo.com"
    if let url = URL(string: "mailto:\(email)") {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

/// To make the text a link. Ex: Text(linkText("Rate in App Store"))
func linkText(_ text: String) -> AttributedString {
    var attributedString = AttributedString(text)
    if let range = attributedString.range(of: text) {
        attributedString[range].foregroundColor = .blue
        attributedString[range].underlineStyle = .single
    }
    return attributedString
}


