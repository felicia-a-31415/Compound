import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(.sRGB, red: r, green: g, blue: b)
    }
}

extension Font {
    static let displayNumber  = Font.system(size: 52, weight: .bold)
    static let headingLarge   = Font.system(size: 28, weight: .semibold)
    static let cardTitle      = Font.system(size: 17, weight: .semibold)
    static let cardTitleSmall = Font.system(size: 15, weight: .semibold)
    static let cardBody       = Font.system(size: 13, weight: .regular)
    static let label          = Font.system(size: 12, weight: .medium)
    static let labelSmall     = Font.system(size: 10, weight: .medium)
    static let sectionHeader  = Font.system(size: 11, weight: .semibold)
}

enum Radius {
    static let card: CGFloat   = 16
    static let tag: CGFloat    = 6
    static let button: CGFloat = 12
}

enum Spacing {
    static let screenHorizontal: CGFloat = 20
    static let cardInset: CGFloat        = 16
    static let sectionGap: CGFloat       = 28
    static let itemGap: CGFloat          = 12
}
