import SwiftUI

struct ActionCardView: View {
    let action: DailyAction
    let isSecondary: Bool
    @Binding var isCompleted: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                PillarTag(pillar: action.pillar)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 11, weight: .medium))
                    Text("\(action.durationMinutes) min")
                        .font(.label)
                }
                .foregroundStyle(Color.appSecondary)
            }

            Spacer().frame(height: 10)

            Text(action.title)
                .font(isSecondary ? .cardTitleSmall : .cardTitle)
                .foregroundStyle(Color.appPrimary)
                .fixedSize(horizontal: false, vertical: true)

            Spacer().frame(height: 8)

            Text(action.body)
                .font(.cardBody)
                .foregroundStyle(Color.appSecondary)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)

            Spacer().frame(height: 16)

            completeButton
        }
        .padding(Spacing.cardInset)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: Radius.card))
        .overlay(
            RoundedRectangle(cornerRadius: Radius.card)
                .stroke(
                    isCompleted ? action.pillar.color.opacity(0.30) : Color.appBorder,
                    lineWidth: 1
                )
        )
        .opacity(isCompleted ? 0.72 : 1.0)
        .animation(.easeInOut(duration: 0.18), value: isCompleted)
    }

    private var completeButton: some View {
        Button {
            withAnimation(.spring(response: 0.28, dampingFraction: 0.72)) {
                isCompleted.toggle()
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(isCompleted ? action.pillar.color : Color.appSecondary)
                Text(isCompleted ? "Completed" : "Mark complete")
                    .font(.label)
                    .foregroundStyle(isCompleted ? action.pillar.color : Color.appSecondary)
            }
        }
        .buttonStyle(.plain)
    }
}
