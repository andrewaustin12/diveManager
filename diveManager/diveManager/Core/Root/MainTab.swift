import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            CoursesView()
                .tabItem {
                    Label("Courses", systemImage: "book")
                }

            ScheduleView()
                .tabItem {
                    Label("Schedule", systemImage: "calendar")
                }

            FinancialView()
                .tabItem {
                    Label("Financials", systemImage: "dollarsign.circle")
                }

            MoreView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(DataModel())
}
