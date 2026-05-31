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
}
