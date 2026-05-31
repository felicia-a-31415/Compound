import SwiftUI

enum Pillar: String, CaseIterable, Hashable, Identifiable {
    case smarter, hotter, richer, happier

    var id: String { rawValue }

    var displayName: String { rawValue.capitalized }

    var color: Color {
        switch self {
        case .smarter: Color(hex: "3B5BDB")
        case .hotter:  Color(hex: "C2255C")
        case .richer:  Color(hex: "E67700")
        case .happier: Color(hex: "2F9E44")
        }
    }

    var tagBackground: Color { color.opacity(0.10) }

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
        case .smarter:
            "Study science and deep focus. For grades, exams, and skills that actually stick."
        case .hotter:
            "Fitness, skincare, sleep, and nutrition. Confidence that comes from showing up for your body."
        case .richer:
            "Budgeting and income basics. The financial foundations most students were never taught."
        case .happier:
            "Stress, motivation, and self-confidence. Evidence-based — no wellness fluff."
        }
    }
}
