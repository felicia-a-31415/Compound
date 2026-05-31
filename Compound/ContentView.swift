import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem { Label("Home", systemImage: "house") }
                .tag(0)

            Color.appBackground
                .ignoresSafeArea()
                .tabItem { Label("Progress", systemImage: "chart.line.uptrend.xyaxis") }
                .tag(1)

            Color.appBackground
                .ignoresSafeArea()
                .tabItem { Label("Profile", systemImage: "person") }
                .tag(2)
        }
        .tint(Color.appPrimary)
    }
}

#Preview {
    ContentView()
}
