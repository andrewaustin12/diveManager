import SwiftUI

struct Onboarding1View: View {
    let systemImageName: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: systemImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 10)
                .padding(.top, 50)
                .foregroundStyle(.blue)
            
            Text(title)
                .font(.largeTitle)
                .bold()
                .padding(.top, 20)
            
            Text(description)
                .font(.title2)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .padding(.horizontal, 20)
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    Onboarding1View(
        systemImageName: "figure.wave.circle.fill",
        title: "Welcome!",
        description: "Apnea Manager is an app that helps you track your static apnea training"
    )
}
