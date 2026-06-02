import Foundation

enum AnthropicService {

    private static let endpoint = URL(string: "https://api.anthropic.com/v1/messages")!
    private static let model    = "claude-sonnet-4-6"

    private static let systemPrompt = """
    Your app speaks like a brilliant, supportive friend who has done all the research so you don't have to — warm but never soft, honest but never harsh. It knows you're busy, it knows some days are harder than others, and it never guilts you for being human. Every action it gives you is intentional and grounded in real science, but it delivers it like a text from someone who genuinely believes in you. It celebrates small wins without being cringe about it. It calls you out gently when your data shows a pattern you haven't noticed yet. Its entire purpose is to make you hotter, smarter, richer, and happier — not someday, but incrementally, starting today — and it speaks with the quiet confidence of something that actually knows how to get you there.
    """

    // MARK: — Public

    static func generateRoadmap(pillars: Set<Pillar>, answers: [String: String]) async -> Roadmap {
        do {
            return try await call(prompt: roadmapPrompt(pillars: pillars, answers: answers))
        } catch {
            return .fallback
        }
    }

    // MARK: — Private networking

    private struct APIResponse: Decodable {
        struct Content: Decodable { let text: String }
        let content: [Content]
    }

    private static func call(prompt: String) async throws -> Roadmap {
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json",    forHTTPHeaderField: "Content-Type")
        request.setValue(APIKeys.anthropic,     forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01",          forHTTPHeaderField: "anthropic-version")
        request.httpBody = try JSONSerialization.data(withJSONObject: [
            "model":      model,
            "max_tokens": 1000,
            "system":     systemPrompt,
            "messages":   [["role": "user", "content": prompt]],
        ])

        let (data, _) = try await URLSession.shared.data(for: request)
        let envelope  = try JSONDecoder().decode(APIResponse.self, from: data)

        guard let text     = envelope.content.first?.text,
              let jsonData = text.data(using: .utf8) else { return .fallback }

        return (try? JSONDecoder().decode(Roadmap.self, from: jsonData)) ?? .fallback
    }

    // MARK: — Prompt construction

    private static let labels: [String: String] = [
        "5_min": "5 minutes", "15_min": "15 minutes", "30_min_plus": "30+ minutes",
        "better_grades": "better grades", "learn_faster": "learn faster",
        "focus": "focus and retention", "burnout": "reduce burnout",
        "no_income": "student with no income", "first_income": "just started earning",
        "saving": "earning but want to do more", "building": "building something",
        "save_money": "save money", "build_skills": "build income skills",
        "start_something": "start something",
        "stress": "stress", "motivation": "motivation", "social_life": "social life",
        "confidence": "self-confidence", "purpose": "sense of purpose",
        "fitness": "fitness", "skincare": "skincare", "style": "style",
        "sleep": "sleep", "nutrition": "nutrition",
        "worked": "yes, it worked", "fell_off": "tried but fell off", "never": "never tried",
    ]

    private static func readable(_ raw: String) -> String {
        raw.split(separator: ",")
            .map { labels[String($0).trimmingCharacters(in: .whitespaces)] ?? String($0) }
            .joined(separator: ", ")
    }

    private static func roadmapPrompt(pillars: Set<Pillar>, answers: [String: String]) -> String {
        var pillarContext = ""
        if pillars.contains(.smarter) {
            if let v = answers["smarter_goal"]     { pillarContext += "\n- Smarter goal: \(readable(v))" }
            if let v = answers["smarter_subjects"], !v.isEmpty { pillarContext += "\n- Subjects/skills: \(v)" }
        }
        if pillars.contains(.hotter) {
            if let v = answers["hotter_focus"]     { pillarContext += "\n- Hotter focus: \(readable(v))" }
            if let v = answers["hotter_routine"], !v.isEmpty  { pillarContext += "\n- Current routine: \(v)" }
        }
        if pillars.contains(.richer) {
            if let v = answers["richer_status"]    { pillarContext += "\n- Financial status: \(readable(v))" }
            if let v = answers["richer_goal"]      { pillarContext += "\n- Richer goal: \(readable(v))" }
        }
        if pillars.contains(.happier) {
            if let v = answers["happier_dragger"]  { pillarContext += "\n- Biggest struggle: \(readable(v))" }
        }

        return """
        Generate a personalized 3-month self-improvement roadmap for a student with the following profile:
        - Selected pillars: \(pillars.map(\.displayName).sorted().joined(separator: ", "))
        - Biggest obstacle: \(answers["biggest_obstacle"] ?? "not specified")
        - Daily time available: \(readable(answers["time_commitment"] ?? ""))
        - Prior system experience: \(readable(answers["prior_experience"] ?? ""))
        - Per-pillar context:\(pillarContext.isEmpty ? " not specified" : pillarContext)

        Return a JSON object with:
        {
          "phase_1": { "title": "Foundation", "description": "2-3 sentences on month 1 focus", "pillar_focuses": ["pillar: focus area"] },
          "phase_2": { "title": "Expansion",  "description": "2-3 sentences on month 2 focus", "pillar_focuses": ["pillar: focus area"] },
          "phase_3": { "title": "Consolidation", "description": "2-3 sentences on month 3 focus", "pillar_focuses": ["pillar: focus area"] },
          "rationale": "2-3 sentences explaining why this roadmap fits this specific user"
        }

        Respond only in JSON. No preamble, no markdown backticks.
        """
    }
}
