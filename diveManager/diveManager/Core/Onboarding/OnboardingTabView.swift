import SwiftUI

struct OnboardingTabView: View {
    
    
    var body: some View {
        
        
        // TabView containing the onboarding screens
        ZStack {
            Image("onboarding-background-image")
                .resizable()
                .opacity(0.6) // Adjust opacity to make it translucent
                .edgesIgnoringSafeArea(.all)
            TabView {
                Onboarding1View(
                    systemImageName: "figure.wave.circle.fill",
                    title: "Welcome!",
                    description: "Dive Manager is an app that helps you track everythign you need as a Dive Pro"
                )
                Onboarding1View(
                    systemImageName: "figure.mind.and.body",
                    title: "Indepth Analytics",
                    description: "Create, track and visualize your data"
                )
                OnboardingFinalView(
                    systemImageName: "target",
                    title: "Reach your goals",
                    description: "Set goals so you can grow revenue"
                )
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
        
    }
}

#Preview {
    OnboardingTabView()
}

