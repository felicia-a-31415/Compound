import SwiftUI

struct OnboardingContainerView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("selectedPillarKeys") private var selectedPillarKeys: String = ""

    @State private var selectedPillars: Set<Pillar> = []
    @State private var intakeAnswers: [String: String] = [:]
    @State private var step: Step = .pillarSelection
    @State private var goingForward = true

    private enum Step: Equatable { case pillarSelection, intake, roadmap }

    var body: some View {
        ZStack {
            switch step {
            case .pillarSelection:
                PillarSelectionView(selectedPillars: $selectedPillars) {
                    selectedPillarKeys = selectedPillars.map(\.rawValue).joined(separator: ",")
                    advance(to: .intake)
                }
                .transition(slide)

            case .intake:
                IntakeQuestionsView(
                    selectedPillars: selectedPillars,
                    onComplete: { answers in
                        intakeAnswers = answers
                        advance(to: .roadmap)
                    },
                    onBack: { retreat(to: .pillarSelection) }
                )
                .transition(slide)

            case .roadmap:
                RoadmapRevealView(
                    selectedPillars: selectedPillars,
                    intakeAnswers: intakeAnswers,
                    onComplete: { hasCompletedOnboarding = true }
                )
                .transition(slide)
            }
        }
        .animation(.spring(response: 0.40, dampingFraction: 0.90), value: step)
    }

    private var slide: AnyTransition {
        .asymmetric(
            insertion: .move(edge: goingForward ? .trailing : .leading).combined(with: .opacity),
            removal:   .move(edge: goingForward ? .leading  : .trailing).combined(with: .opacity)
        )
    }

    private func advance(to next: Step) {
        goingForward = true
        step = next
    }

    private func retreat(to previous: Step) {
        goingForward = false
        step = previous
    }
}
