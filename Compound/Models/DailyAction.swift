import Foundation

struct DailyAction: Identifiable {
    let id: UUID
    let title: String
    let body: String
    let pillar: Pillar
    let durationMinutes: Int

    init(title: String, body: String, pillar: Pillar, durationMinutes: Int) {
        self.id = UUID()
        self.title = title
        self.body = body
        self.pillar = pillar
        self.durationMinutes = durationMinutes
    }
}

extension DailyAction {
    static let samplePrimary = DailyAction(
        title: "Prime your memory before you open a book",
        body: "Before your first study session today, write down three things you want to remember by the end. Check them afterward. This is active recall priming — it tells your brain what to prioritize encoding before you even begin.",
        pillar: .smarter,
        durationMinutes: 10
    )

    static let sampleSecondary = DailyAction(
        title: "Wash your face before bed",
        body: "Tonight, wash your face before bed. Habit anchoring — attaching a new behavior to an existing one — is the most reliable way to make it stick.",
        pillar: .hotter,
        durationMinutes: 2
    )
}
