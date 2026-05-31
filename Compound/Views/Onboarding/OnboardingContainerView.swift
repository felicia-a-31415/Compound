import SwiftUI

struct OnboardingContainerView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("selectedPillarKeys") private var selectedPillarKeys: String = ""

    @State private var selectedPillars: Set<Pillar> = []
    @State private var intakeAnswers: [String: String] = [:]
    @State private var step: Step = .pillarSelection

    private enum Step: Equatable { case pillarSelection, intake }

    var body: some View {
        ZStack {
            switch step {
            case .pillarSelection:
                PillarSelectionView(selectedPillars: $selectedPillars) {
                    selectedPillarKeys = selectedPillars.map(\.rawValue).joined(separator: ",")
                    step = .intake
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .leading).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))

            case .intake:
                IntakeQuestionsView(
                    selectedPillars: selectedPillars,
                    onComplete: { answers in
                        intakeAnswers = answers
                        hasCompletedOnboarding = true
                    },
                    onBack: { step = .pillarSelection }
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .trailing).combined(with: .opacity)
                ))
            }
        }
        .animation(.spring(response: 0.40, dampingFraction: 0.90), value: step)
    }
}
