import SwiftUI

struct PillarRingPreview: View {
    let pillar: Pillar
    let progress: Double

    @State private var drawn: Double = 0

    private let ringSize: CGFloat = 40
    private let strokeWidth: CGFloat = 3

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .stroke(pillar.color.opacity(0.12), lineWidth: strokeWidth)
                    .frame(width: ringSize, height: ringSize)

                Circle()
                    .trim(from: 0, to: drawn)
                    .stroke(
                        pillar.color,
                        style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round)
                    )
                    .frame(width: ringSize, height: ringSize)
                    .rotationEffect(.degrees(-90))
            }

            Text(pillar.displayName)
                .font(.labelSmall)
                .foregroundStyle(Color.appSecondary)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.9).delay(0.2)) {
                drawn = progress
            }
        }
    }
}
