import SwiftUI

struct OnboardingFinalView: View {
    let systemImageName: String
    let title: String
    let description: String
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false

    @State private var isAnimating = false

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
                .symbolEffect(.variableColor, value: isAnimating)
                .foregroundStyle(.blue, .gray)
            
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
            
            Button {
                hasCompletedOnboarding = true
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack {
                    Text("Continue")
                        .font(.title)
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .padding()
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                .background(Color.blue.opacity(0.7)) // Use a complementary light blue color
                .cornerRadius(10)
            }
            .padding(.bottom, 50)
        }
        .padding(.horizontal, 40)
        
        .onAppear {
            withAnimation(.easeInOut(duration: 100.0).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
        
    }
}

#Preview {
    OnboardingFinalView(
        systemImageName: "target",
        title: "Set Goals",
        description: "Create goals so you can track your progress"
    )
}
