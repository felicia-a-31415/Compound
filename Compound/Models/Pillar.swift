import SwiftUI

enum Pillar: String, CaseIterable, Hashable, Identifiable {
    case smarter, hotter, richer, happier

    var id: String { rawValue }

    var displayName: String { rawValue.capitalized }

    var color: Color {
        switch self {
        case .smarter: .brandTealBlue
        case .hotter:  .accentWarmPink
        case .richer:  .brandTurquoise
        case .happier: .brandFrostedBlue
        }
    }

    var tagBackground: Color { .appTagBackground }

    var iconName: String {
        switch self {
        case .smarter: "book.closed.fill"
        case .hotter:  "bolt.fill"
        case .richer:  "chart.line.uptrend.xyaxis"
        case .happier: "heart.fill"
        }
    }

    var tagline: String {
        switch self {
        case .smarter: "Grades, focus, and learning to learn."
        case .hotter:  "Fitness, sleep, skincare, and nutrition."
        case .richer:  "Money basics most students were never taught."
        case .happier: "Stress, confidence, and motivation."
        }
    }
}
