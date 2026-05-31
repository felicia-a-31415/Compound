import SwiftUI

struct PillarSelectionView: View {
    @Binding var selectedPillars: Set<Pillar>
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    heading
                        .padding(.top, 64)

                    cards
                        .padding(.top, 36)

                    Spacer(minLength: 32)
                }
                .padding(.horizontal, Spacing.screenHorizontal)
            }

            continueButton
                .padding(.horizontal, Spacing.screenHorizontal)
                .padding(.top, 12)
                .padding(.bottom, 40)
        }
        .background(Color.appBackground.ignoresSafeArea())
    }

    private var heading: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("What do you want\nto work on?")
                .font(.system(size: 32, weight: .semibold))
                .foregroundStyle(Color.appPrimary)
                .lineSpacing(2)

            Text("Pick one or more. You can change this anytime.")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(Color.appSecondary)
        }
    }

    private var cards: some View {
        VStack(spacing: 10) {
            ForEach(Pillar.allCases) { pillar in
                PillarCardView(
                    pillar: pillar,
                    isSelected: selectedPillars.contains(pillar)
                ) {
                    withAnimation(.spring(response: 0.24, dampingFraction: 0.8)) {
                        if selectedPillars.contains(pillar) {
                            selectedPillars.remove(pillar)
                        } else {
                            selectedPillars.insert(pillar)
                        }
                    }
                }
            }
        }
    }

    private var continueButton: some View {
        let enabled = !selectedPillars.isEmpty
        return Button(action: onContinue) {
            Text("Continue")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(enabled ? .white : Color.appSecondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: Radius.button)
                        .fill(enabled ? Color.appPrimary : Color.appBorder)
                )
        }
        .disabled(!enabled)
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: enabled)
    }
}

private struct PillarCardView: View {
    let pillar: Pillar
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                Image(systemName: pillar.iconName)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(isSelected ? pillar.color : Color.appSecondary)
                    .frame(width: 26, alignment: .center)

                VStack(alignment: .leading, spacing: 4) {
                    Text(pillar.displayName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.appPrimary)

                    Text(pillar.tagline)
                        .font(.cardBody)
                        .foregroundStyle(Color.appSecondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22, weight: .regular))
                    .foregroundStyle(isSelected ? pillar.color : Color.appBorder)
            }
            .padding(Spacing.cardInset)
            .background(isSelected ? pillar.color.opacity(0.04) : Color.appCard)
            .clipShape(RoundedRectangle(cornerRadius: Radius.card))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.card)
                    .stroke(
                        isSelected ? pillar.color.opacity(0.45) : Color.appBorder,
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.22, dampingFraction: 0.8), value: isSelected)
    }
}

#Preview {
    PillarSelectionView(selectedPillars: .constant([.smarter, .happier])) {}
}
