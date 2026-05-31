import SwiftUI

struct HomeView: View {
    @Binding var selectedTab: Int

    @State private var primaryCompleted = false
    @State private var secondaryCompleted = false

    private let userName = "Lela"
    private let streakDays = 7
    private let chapter = 1

    private struct PillarProgress: Identifiable {
        let id: Pillar
        let value: Double
    }

    private let pillarProgress: [PillarProgress] = [
        PillarProgress(id: .smarter, value: 0.62),
        PillarProgress(id: .hotter,  value: 0.34),
        PillarProgress(id: .richer,  value: 0.48),
        PillarProgress(id: .happier, value: 0.71),
    ]

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 { return "Good morning," }
        if hour < 17 { return "Good afternoon," }
        return "Good evening,"
    }

    private var showReflect: Bool {
        let hour = Calendar.current.component(.hour, from: Date())
        return (primaryCompleted && secondaryCompleted) || hour >= 18
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                header
                    .padding(.horizontal, Spacing.screenHorizontal)
                    .padding(.top, 20)

                streakRow
                    .padding(.horizontal, Spacing.screenHorizontal)
                    .padding(.top, Spacing.sectionGap)

                pillarRings
                    .padding(.horizontal, Spacing.screenHorizontal)
                    .padding(.top, 20)

                actionsSection
                    .padding(.top, Spacing.sectionGap)

                if showReflect {
                    reflectButton
                        .padding(.horizontal, Spacing.screenHorizontal)
                        .padding(.top, Spacing.itemGap)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                Spacer(minLength: 40)
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
        .animation(.easeInOut(duration: 0.25), value: showReflect)
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text(greeting)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(Color.appSecondary)
                Text("\(userName).")
                    .font(.headingLarge)
                    .foregroundStyle(Color.appPrimary)
            }
            Spacer()
            Text("Chapter \(chapter)")
                .font(.label)
                .foregroundStyle(Color.appSecondary)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.appBorder)
                .clipShape(Capsule())
                .padding(.top, 4)
        }
    }

    private var streakRow: some View {
        HStack(alignment: .firstTextBaseline, spacing: 7) {
            Text("\(streakDays)")
                .font(.displayNumber)
                .foregroundStyle(Color.appPrimary)
            VStack(alignment: .leading, spacing: 0) {
                Text("day")
                Text("streak")
            }
            .font(.system(size: 13, weight: .medium))
            .foregroundStyle(Color.appSecondary)
        }
    }

    private var pillarRings: some View {
        HStack(spacing: 18) {
            ForEach(pillarProgress) { item in
                PillarRingPreview(pillar: item.id, progress: item.value)
                    .onTapGesture { selectedTab = 1 }
            }
            Spacer()
        }
    }

    private var actionsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.itemGap) {
            Text("Today's actions")
                .font(.sectionHeader)
                .foregroundStyle(Color.appSecondary)
                .textCase(.uppercase)
                .kerning(0.5)
                .padding(.horizontal, Spacing.screenHorizontal)

            ActionCardView(
                action: .samplePrimary,
                isSecondary: false,
                isCompleted: $primaryCompleted
            )
            .padding(.horizontal, Spacing.screenHorizontal)

            ActionCardView(
                action: .sampleSecondary,
                isSecondary: true,
                isCompleted: $secondaryCompleted
            )
            .padding(.horizontal, Spacing.screenHorizontal)
        }
    }

    private var reflectButton: some View {
        Button {
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Reflect on today")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.appPrimary)
                    Text("Takes about 2 minutes")
                        .font(.label)
                        .foregroundStyle(Color.appSecondary)
                }
                Spacer()
                Image(systemName: "arrow.right")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.appSecondary)
            }
            .padding(Spacing.cardInset)
            .background(Color.appCard)
            .clipShape(RoundedRectangle(cornerRadius: Radius.card))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.card)
                    .stroke(Color.appBorder, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContentView()
}
