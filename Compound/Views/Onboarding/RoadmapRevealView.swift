import SwiftUI

struct RoadmapRevealView: View {
    let selectedPillars: Set<Pillar>
    let intakeAnswers: [String: String]
    let onComplete: () -> Void

    @State private var roadmap: Roadmap?
    @State private var revealed = false

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            if let roadmap {
                revealContent(roadmap)
                    .transition(.opacity)
            } else {
                loadingView
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.45), value: roadmap != nil)
        .task { await load() }
    }

    // MARK: — Loading

    private var loadingView: some View {
        VStack(spacing: 20) {
            SpinnerView()

            VStack(spacing: 6) {
                Text("Building your roadmap")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.appPrimary)
                Text("Just a moment.")
                    .font(.cardBody)
                    .foregroundStyle(Color.appSecondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: — Reveal

    private func revealContent(_ roadmap: Roadmap) -> some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    revealHeader
                        .padding(.top, 60)

                    phaseCards(roadmap)
                        .padding(.top, 36)

                    rationaleSection(roadmap.rationale)
                        .padding(.top, 28)

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, Spacing.screenHorizontal)
            }

            letsStartButton
                .padding(.horizontal, Spacing.screenHorizontal)
                .padding(.top, 12)
                .padding(.bottom, 40)
        }
    }

    private var revealHeader: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Chapter 1")
                .font(.label)
                .foregroundStyle(Color.brandTealBlue)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.brandTealBlue.opacity(0.10))
                .clipShape(Capsule())
                .opacity(revealed ? 1 : 0)
                .animation(.easeOut(duration: 0.4), value: revealed)

            Text("Your roadmap\nis ready.")
                .font(.headingSerif)
                .foregroundStyle(Color.appPrimary)
                .opacity(revealed ? 1 : 0)
                .offset(y: revealed ? 0 : 12)
                .animation(.spring(response: 0.5, dampingFraction: 0.85).delay(0.08), value: revealed)
        }
    }

    private func phaseCards(_ roadmap: Roadmap) -> some View {
        VStack(spacing: 12) {
            PhaseCardView(phase: roadmap.phase1, month: 1, revealed: revealed, delay: 0.20)
            PhaseCardView(phase: roadmap.phase2, month: 2, revealed: revealed, delay: 0.32)
            PhaseCardView(phase: roadmap.phase3, month: 3, revealed: revealed, delay: 0.44)
        }
    }

    private func rationaleSection(_ text: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Why this roadmap")
                .font(.sectionHeader)
                .foregroundStyle(Color.appSecondary)
                .textCase(.uppercase)
                .kerning(0.5)

            Text(text)
                .font(.cardBody)
                .foregroundStyle(Color.appSecondary)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
        }
        .opacity(revealed ? 1 : 0)
        .offset(y: revealed ? 0 : 10)
        .animation(.easeOut(duration: 0.4).delay(0.58), value: revealed)
    }

    private var letsStartButton: some View {
        Button(action: onComplete) {
            HStack(spacing: 8) {
                Text("Let's start")
                Image(systemName: "arrow.right")
                    .font(.system(size: 14, weight: .semibold))
            }
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: Radius.button)
                    .fill(Color.brandTealBlue)
            )
        }
        .buttonStyle(.plain)
        .opacity(revealed ? 1 : 0)
        .animation(.easeOut(duration: 0.3).delay(0.70), value: revealed)
    }

    // MARK: — Data loading

    private func load() async {
        let result = await AnthropicService.generateRoadmap(
            pillars: selectedPillars,
            answers: intakeAnswers
        )
        roadmap = result
        withAnimation(.spring(response: 0.5, dampingFraction: 0.85).delay(0.25)) {
            revealed = true
        }
    }
}

// MARK: — Phase card

private struct PhaseCardView: View {
    let phase: Roadmap.Phase
    let month: Int
    let revealed: Bool
    let delay: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Month \(month)")
                .font(.labelSmall)
                .foregroundStyle(Color.appSecondary)

            Text(phase.title)
                .font(.cardTitle)
                .foregroundStyle(Color.appPrimary)

            Text(phase.description)
                .font(.cardBody)
                .foregroundStyle(Color.appSecondary)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)

            if !phase.pillarFocuses.isEmpty {
                HStack(spacing: 6) {
                    ForEach(phase.pillarFocuses, id: \.self) { focus in
                        FocusChipView(focus: focus)
                    }
                    Spacer()
                }
                .padding(.top, 2)
            }
        }
        .padding(Spacing.cardInset)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: Radius.card))
        .overlay(
            RoundedRectangle(cornerRadius: Radius.card)
                .stroke(Color.appBorder, lineWidth: 1)
        )
        .opacity(revealed ? 1 : 0)
        .offset(y: revealed ? 0 : 16)
        .animation(.spring(response: 0.5, dampingFraction: 0.85).delay(delay), value: revealed)
    }
}

// MARK: — Focus chip

private struct FocusChipView: View {
    let focus: String

    private var pillar: Pillar? {
        let prefix = focus.split(separator: ":").first?
            .trimmingCharacters(in: .whitespaces).lowercased() ?? ""
        return Pillar.allCases.first { $0.rawValue == prefix }
    }

    var body: some View {
        if let pillar {
            PillarTag(pillar: pillar)
        } else {
            Text(focus)
                .font(.labelSmall)
                .foregroundStyle(Color.appSecondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.appBorder.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: Radius.tag))
        }
    }
}

// MARK: — Spinner

private struct SpinnerView: View {
    @State private var rotation: Double = 0

    var body: some View {
        Circle()
            .trim(from: 0, to: 0.72)
            .stroke(Color.brandTealBlue, style: StrokeStyle(lineWidth: 3, lineCap: .round))
            .frame(width: 40, height: 40)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(.linear(duration: 0.9).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
    }
}

#Preview {
    RoadmapRevealView(
        selectedPillars: [.smarter, .happier],
        intakeAnswers: [:]
    ) {}
}
