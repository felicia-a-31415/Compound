import SwiftUI

// MARK: — Brand palette (fixed, non-adaptive)

extension Color {
    static let brandDeepTwilight = Color(hex: "03045E")
    static let brandTealBlue     = Color(hex: "0077B6")
    static let brandTurquoise    = Color(hex: "00B4D8")
    static let brandFrostedBlue  = Color(hex: "90E0EF")
    static let brandLightCyan    = Color(hex: "CAF0F8")
    static let accentWarmPink    = Color(hex: "E5547C")
}

// MARK: — Adaptive semantic tokens

extension Color {
    static let appBackground = Color(uiColor: UIColor { t in
        t.userInterfaceStyle == .dark
            ? UIColor(red: 3/255,   green: 4/255,   blue: 94/255,  alpha: 1) // brandDeepTwilight
            : UIColor(red: 202/255, green: 240/255, blue: 248/255, alpha: 1) // brandLightCyan
    })

    static let appCard = Color(uiColor: UIColor { t in
        t.userInterfaceStyle == .dark
            ? UIColor(red: 8/255,   green: 18/255,  blue: 122/255, alpha: 1) // elevated navy
            : UIColor(red: 144/255, green: 224/255, blue: 239/255, alpha: 1) // brandFrostedBlue
    })

    static let appPrimary = Color(uiColor: UIColor { t in
        t.userInterfaceStyle == .dark
            ? UIColor(red: 202/255, green: 240/255, blue: 248/255, alpha: 1) // brandLightCyan
            : UIColor(red: 3/255,   green: 4/255,   blue: 94/255,  alpha: 1) // brandDeepTwilight
    })

    static let appSecondary = Color(uiColor: UIColor { t in
        t.userInterfaceStyle == .dark
            ? UIColor(red: 144/255, green: 224/255, blue: 239/255, alpha: 0.75) // brandFrostedBlue dimmed
            : UIColor(red: 0/255,   green: 119/255, blue: 182/255, alpha: 0.70) // brandTealBlue dimmed
    })

    static let appBorder = Color(uiColor: UIColor { t in
        t.userInterfaceStyle == .dark
            ? UIColor(red: 0/255,   green: 119/255, blue: 182/255, alpha: 0.35) // tealBlue border
            : UIColor(red: 0/255,   green: 180/255, blue: 216/255, alpha: 0.38) // turquoise border
    })

    static let appTagBackground = Color(uiColor: UIColor { t in
        t.userInterfaceStyle == .dark
            ? UIColor(white: 1, alpha: 0.12)
            : UIColor(white: 1, alpha: 0.60)
    })
}

// MARK: — Typography additions (New York serif)

extension Font {
    static let displaySerif = Font.system(size: 52, weight: .bold,     design: .serif)
    static let headingSerif = Font.system(size: 32, weight: .semibold, design: .serif)
}
