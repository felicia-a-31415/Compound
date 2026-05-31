import SwiftUI

struct OnboardingContainerView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("selectedPillarKeys") private var selectedPillarKeys: String = ""

    @State private var selectedPillars: Set<Pillar> = []

    var body: some View {
        PillarSelectionView(selectedPillars: $selectedPillars) {
            selectedPillarKeys = selectedPillars.map(\.rawValue).joined(separator: ",")
            hasCompletedOnboarding = true
        }
    }
}
