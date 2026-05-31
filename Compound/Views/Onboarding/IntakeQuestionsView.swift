import SwiftUI

struct IntakeQuestionsView: View {
    let selectedPillars: Set<Pillar>
    let onComplete: ([String: String]) -> Void
    let onBack: () -> Void

    @State private var currentIndex = 0
    @State private var answers: [String: String] = [:]
    @State private var goingForward = true

    private var questions: [IntakeQuestion] {
        IntakeQuestion.questions(for: selectedPillars)
    }

    private var progress: Double {
        guard !questions.isEmpty else { return 0 }
        return Double(currentIndex + 1) / Double(questions.count)
    }

    var body: some View {
        VStack(spacing: 0) {
            progressHeader
                .padding(.horizontal, Spacing.screenHorizontal)
                .padding(.top, 16)
                .padding(.bottom, 8)

            ZStack {
                if currentIndex < questions.count {
                    QuestionPageView(
                        question: questions[currentIndex],
                        answer: answerBinding(for: questions[currentIndex].id),
                        onSubmit: advance
                    )
                    .id(currentIndex)
                    .transition(.asymmetric(
                        insertion: .move(edge: goingForward ? .trailing : .leading)
                            .combined(with: .opacity),
                        removal: .move(edge: goingForward ? .leading : .trailing)
                            .combined(with: .opacity)
                    ))
                }
            }
            .animation(.spring(response: 0.36, dampingFraction: 0.88), value: currentIndex)
        }
        .background(Color.appBackground.ignoresSafeArea())
    }

    private var progressHeader: some View {
        HStack(spacing: 14) {
            Button(action: handleBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.appPrimary)
            }
            .buttonStyle(.plain)

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.appBorder)
                    .frame(height: 4)
                Capsule()
                    .fill(Color.brandTealBlue)
                    .frame(height: 4)
                    .scaleEffect(x: progress, anchor: .leading)
                    .animation(.easeInOut(duration: 0.35), value: progress)
            }

            Text("\(currentIndex + 1)/\(questions.count)")
                .font(.labelSmall)
                .foregroundStyle(Color.appSecondary)
                .monospacedDigit()
                .frame(width: 30, alignment: .trailing)
        }
    }

    private func answerBinding(for key: String) -> Binding<String> {
        Binding(
            get: { answers[key] ?? "" },
            set: { answers[key] = $0 }
        )
    }

    private func advance() {
        goingForward = true
        if currentIndex < questions.count - 1 {
            currentIndex += 1
        } else {
            onComplete(answers)
        }
    }

    private func handleBack() {
        if currentIndex > 0 {
            goingForward = false
            currentIndex -= 1
        } else {
            onBack()
        }
    }
}

// MARK: — Single question page

private struct QuestionPageView: View {
    let question: IntakeQuestion
    @Binding var answer: String
    let onSubmit: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    questionHeader
                        .padding(.top, 40)

                    questionInput
                        .padding(.top, 28)

                    Spacer(minLength: 32)
                }
                .padding(.horizontal, Spacing.screenHorizontal)
            }
            .scrollDismissesKeyboard(.interactively)

            if showsContinueButton {
                continueButton
                    .padding(.horizontal, Spacing.screenHorizontal)
                    .padding(.top, 12)
                    .padding(.bottom, 40)
            }
        }
    }

    private var questionHeader: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(question.prompt)
                .font(.system(size: 26, weight: .semibold))
                .foregroundStyle(Color.appPrimary)
                .fixedSize(horizontal: false, vertical: true)

            if let sub = question.subtext {
                Text(sub)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(Color.appSecondary)
            }
        }
    }

    @ViewBuilder
    private var questionInput: some View {
        switch question.type {
        case .freeText(let placeholder):
            FreeTextInputView(placeholder: placeholder, answer: $answer)
        case .singleSelect(let options):
            SingleSelectInputView(options: options, answer: $answer, onSelect: onSubmit)
        case .multiSelect(let options):
            MultiSelectInputView(options: options, answer: $answer)
        }
    }

    private var showsContinueButton: Bool {
        switch question.type {
        case .freeText, .multiSelect: true
        case .singleSelect: false
        }
    }

    private var continueEnabled: Bool {
        switch question.type {
        case .freeText: true
        case .multiSelect: !answer.isEmpty
        case .singleSelect: !answer.isEmpty
        }
    }

    private var continueButton: some View {
        Button(action: onSubmit) {
            Text("Continue")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(continueEnabled ? .white : Color.appSecondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: Radius.button)
                        .fill(continueEnabled ? Color.appPrimary : Color.appBorder)
                )
        }
        .disabled(!continueEnabled)
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: continueEnabled)
    }
}

// MARK: — Input components

private struct FreeTextInputView: View {
    let placeholder: String
    @Binding var answer: String
    @FocusState private var isFocused: Bool

    var body: some View {
        TextField(placeholder, text: $answer, axis: .vertical)
            .font(.system(size: 16, weight: .regular))
            .foregroundStyle(Color.appPrimary)
            .lineLimit(1...5)
            .focused($isFocused)
            .padding(Spacing.cardInset)
            .background(Color.appCard)
            .clipShape(RoundedRectangle(cornerRadius: Radius.card))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.card)
                    .stroke(isFocused ? Color.brandTealBlue : Color.appBorder, lineWidth: 1)
                    .animation(.easeInOut(duration: 0.15), value: isFocused)
            )
            .task {
                try? await Task.sleep(for: .milliseconds(420))
                isFocused = true
            }
    }
}

private struct SingleSelectInputView: View {
    let options: [SelectOption]
    @Binding var answer: String
    let onSelect: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            ForEach(options) { option in
                let isSelected = answer == option.id
                Button {
                    answer = option.id
                    Task {
                        try? await Task.sleep(for: .milliseconds(200))
                        onSelect()
                    }
                } label: {
                    HStack {
                        Text(option.label)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(isSelected ? Color.brandTealBlue : Color.appPrimary)
                        Spacer()
                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 18))
                            .foregroundStyle(isSelected ? Color.brandTealBlue : Color.appBorder)
                    }
                    .padding(Spacing.cardInset)
                    .background(isSelected ? Color.brandTealBlue.opacity(0.07) : Color.appCard)
                    .clipShape(RoundedRectangle(cornerRadius: Radius.card))
                    .overlay(
                        RoundedRectangle(cornerRadius: Radius.card)
                            .stroke(
                                isSelected ? Color.brandTealBlue.opacity(0.5) : Color.appBorder,
                                lineWidth: 1
                            )
                    )
                }
                .buttonStyle(.plain)
                .animation(.spring(response: 0.22, dampingFraction: 0.8), value: isSelected)
            }
        }
    }
}

private struct MultiSelectInputView: View {
    let options: [SelectOption]
    @Binding var answer: String

    private var selected: Set<String> {
        Set(answer.split(separator: ",").map(String.init).filter { !$0.isEmpty })
    }

    private func toggle(_ id: String) {
        var set = selected
        if set.contains(id) { set.remove(id) } else { set.insert(id) }
        answer = set.sorted().joined(separator: ",")
    }

    var body: some View {
        VStack(spacing: 10) {
            ForEach(options) { option in
                let isSelected = selected.contains(option.id)
                Button {
                    withAnimation(.spring(response: 0.22, dampingFraction: 0.8)) {
                        toggle(option.id)
                    }
                } label: {
                    HStack {
                        Text(option.label)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(isSelected ? Color.brandTealBlue : Color.appPrimary)
                        Spacer()
                        Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                            .font(.system(size: 18))
                            .foregroundStyle(isSelected ? Color.brandTealBlue : Color.appBorder)
                    }
                    .padding(Spacing.cardInset)
                    .background(isSelected ? Color.brandTealBlue.opacity(0.07) : Color.appCard)
                    .clipShape(RoundedRectangle(cornerRadius: Radius.card))
                    .overlay(
                        RoundedRectangle(cornerRadius: Radius.card)
                            .stroke(
                                isSelected ? Color.brandTealBlue.opacity(0.5) : Color.appBorder,
                                lineWidth: 1
                            )
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
}
