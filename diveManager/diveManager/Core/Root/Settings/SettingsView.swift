import SwiftUI
import WishKit
//import RevenueCat
//import RevenueCatUI

struct SettingsView: View {
    @State private var taxRate: Double = UserDefaults.standard.taxRate
    @State private var commissionRate: Double = UserDefaults.standard.commissionRate
    @State private var selectedCurrency: Currency = UserDefaults.standard.currency
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section("Customization") {
                        HStack {
                            Image(systemName: "dollarsign.circle")
                                .foregroundStyle(Color.teal)
                            Stepper("Tax Rate: \(taxRate, specifier: "%.0f")%", value: $taxRate, in: 0...100, step: 1, onEditingChanged: { _ in
                                UserDefaults.standard.taxRate = taxRate
                            })
                        }
                        
                        HStack {
                            Image(systemName: "dollarsign.circle")
                                .foregroundStyle(Color.teal)
                            Stepper("Commission Rate: \(commissionRate, specifier: "%.0f")%", value: $commissionRate, in: 0...100, step: 1, onEditingChanged: { _ in
                                UserDefaults.standard.commissionRate = commissionRate
                            })
                        }
                        
                        HStack {
                            Image(systemName: selectedCurrency.iconName)
                                .foregroundStyle(Color.teal)
                            Picker("Currency", selection: $selectedCurrency) {
                                ForEach(Currency.allCases, id: \.self) { currency in
                                    Text(currency.rawValue).tag(currency)
                                        
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                        .onChange(of: selectedCurrency) { newValue in
                            UserDefaults.standard.currency = newValue
                        }
                    }
                    
                    
                    Section("Support") {
                        NavigationLink(destination: WishKit.view) {
                            Label {
                                Text("Feature Request")
                            } icon: {
                                Image(systemName: "lightbulb.min")
                                    .foregroundStyle(Color.teal)
                            }
                        }
                        Label {
                            Text("Feedback")
                        } icon: {
                            Image(systemName: "envelope")
                                .foregroundStyle(Color.teal)
                        }
                        .onTapGesture {
                            sendEmail()
                        }
                        
                        Label {
                            HStack {
                                Text("Rate in the App Store")
                                Spacer()
                                Image(systemName: "link")
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
        .environmentObject(DataModel())
}

func openAppStoreForRating() {
    //    guard let url = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID") else {
    //        return // Invalid URL
    //    }
    //    if UIApplication.shared.canOpenURL(url) {
    //        UIApplication.shared.open(url)
    //    }
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


/// this goes into the support section

//                        NavigationLink(destination: WishKit.view) {
//                            Label("Feature Request", systemImage: "lightbulb.min")
//                        }
//
//                        NavigationLink(destination: BuyMeACoffeeView()) {
//                            Label("Buy me a coffee", systemImage: "mug.fill")
//                        }
