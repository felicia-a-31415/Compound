import Foundation

struct SelectOption: Identifiable {
    let id: String
    let label: String
}

struct IntakeQuestion: Identifiable {
    let id: String
    let prompt: String
    let subtext: String?
    let type: QuestionType

    enum QuestionType {
        case freeText(placeholder: String)
        case singleSelect(options: [SelectOption])
        case multiSelect(options: [SelectOption])
    }
}

// MARK: — Question definitions

extension IntakeQuestion {

    // Universal

    static let biggestObstacle = IntakeQuestion(
        id: "biggest_obstacle",
        prompt: "What's your biggest obstacle right now?",
        subtext: nil,
        type: .freeText(placeholder: "Be specific — this shapes everything")
    )

    static let timeCommitment = IntakeQuestion(
        id: "time_commitment",
        prompt: "How much time can you realistically commit daily?",
        subtext: "Think your worst day, not your best.",
        type: .singleSelect(options: [
            SelectOption(id: "5_min",       label: "5 minutes"),
            SelectOption(id: "15_min",      label: "15 minutes"),
            SelectOption(id: "30_min_plus", label: "30 minutes or more"),
        ])
    )

    // Smarter

    static let smarterGoal = IntakeQuestion(
        id: "smarter_goal",
        prompt: "What's your main goal?",
        subtext: nil,
        type: .singleSelect(options: [
            SelectOption(id: "better_grades", label: "Better grades"),
            SelectOption(id: "learn_faster",  label: "Learn faster"),
            SelectOption(id: "focus",         label: "Focus and retention"),
            SelectOption(id: "burnout",       label: "Reduce burnout"),
        ])
    )

    static let smarterSubjects = IntakeQuestion(
        id: "smarter_subjects",
        prompt: "What subjects or skills are you focused on?",
        subtext: nil,
        type: .freeText(placeholder: "e.g. calculus, Python, essay writing")
    )

    // Hotter

    static let hotterFocus = IntakeQuestion(
        id: "hotter_focus",
        prompt: "What's your focus?",
        subtext: "Pick everything that applies.",
        type: .multiSelect(options: [
            SelectOption(id: "fitness",   label: "Fitness"),
            SelectOption(id: "skincare",  label: "Skincare"),
            SelectOption(id: "style",     label: "Style"),
            SelectOption(id: "sleep",     label: "Sleep"),
            SelectOption(id: "nutrition", label: "Nutrition"),
        ])
    )

    static let hotterRoutine = IntakeQuestion(
        id: "hotter_routine",
        prompt: "What does your current routine look like?",
        subtext: nil,
        type: .freeText(placeholder: "Even \"nothing\" is useful here")
    )

    // Richer

    static let richerStatus = IntakeQuestion(
        id: "richer_status",
        prompt: "Where are you at financially?",
        subtext: nil,
        type: .singleSelect(options: [
            SelectOption(id: "no_income",    label: "Student with no income"),
            SelectOption(id: "first_income", label: "Just started earning"),
            SelectOption(id: "saving",       label: "Earning but want to do more"),
            SelectOption(id: "building",     label: "Building something"),
        ])
    )

    static let richerGoal = IntakeQuestion(
        id: "richer_goal",
        prompt: "What's your goal?",
        subtext: nil,
        type: .singleSelect(options: [
            SelectOption(id: "save_money",      label: "Save money"),
            SelectOption(id: "build_skills",    label: "Build income skills"),
            SelectOption(id: "start_something", label: "Start something"),
        ])
    )

    // Happier

    static let happierDragger = IntakeQuestion(
        id: "happier_dragger",
        prompt: "What's dragging you down most?",
        subtext: nil,
        type: .singleSelect(options: [
            SelectOption(id: "stress",      label: "Stress"),
            SelectOption(id: "motivation",  label: "Motivation"),
            SelectOption(id: "social_life", label: "Social life"),
            SelectOption(id: "confidence",  label: "Self-confidence"),
            SelectOption(id: "purpose",     label: "Sense of purpose"),
        ])
    )

    // Closing

    static let priorExperience = IntakeQuestion(
        id: "prior_experience",
        prompt: "Have you tried self-improvement systems before?",
        subtext: nil,
        type: .singleSelect(options: [
            SelectOption(id: "worked",   label: "Yes — and it worked"),
            SelectOption(id: "fell_off", label: "Tried but fell off"),
            SelectOption(id: "never",    label: "Never tried"),
        ])
    )

    // MARK: — Build ordered list from selected pillars

    static func questions(for pillars: Set<Pillar>) -> [IntakeQuestion] {
        var list: [IntakeQuestion] = [.biggestObstacle, .timeCommitment]
        if pillars.contains(.smarter) { list += [.smarterGoal, .smarterSubjects] }
        if pillars.contains(.hotter)  { list += [.hotterFocus, .hotterRoutine] }
        if pillars.contains(.richer)  { list += [.richerStatus, .richerGoal] }
        if pillars.contains(.happier) { list += [.happierDragger] }
        list.append(.priorExperience)
        return list
    }
}
