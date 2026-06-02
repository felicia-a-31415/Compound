import Foundation

struct Roadmap: Codable {
    struct Phase: Codable {
        let title: String
        let description: String
        let pillarFocuses: [String]

        enum CodingKeys: String, CodingKey {
            case title, description
            case pillarFocuses = "pillar_focuses"
        }
    }

    let phase1: Phase
    let phase2: Phase
    let phase3: Phase
    let rationale: String

    enum CodingKeys: String, CodingKey {
        case phase1 = "phase_1"
        case phase2 = "phase_2"
        case phase3 = "phase_3"
        case rationale
    }
}

extension Roadmap {
    static let fallback = Roadmap(
        phase1: Phase(
            title: "Foundation",
            description: "The first month is about one thing: showing up. Small, consistent actions that prove to you — and to the app — that you can do this every day, even on the hard ones.",
            pillarFocuses: ["Start small, show up daily"]
        ),
        phase2: Phase(
            title: "Expansion",
            description: "With 30 days of data, actions get more specific and a little harder. You've earned the right to be pushed. We use what worked to design what comes next.",
            pillarFocuses: ["Build on what's working"]
        ),
        phase3: Phase(
            title: "Consolidation",
            description: "Make what works permanent and let go of what doesn't. The goal this month is sustainable habits, not peak performance. Your quarterly review is at the end.",
            pillarFocuses: ["Solidify and reflect"]
        ),
        rationale: "This roadmap builds momentum gradually — consistency first, intensity second. The data you generate in chapter one becomes the foundation for a more personalized chapter two."
    )
}
