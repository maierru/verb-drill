import SwiftUI

struct DrillView: View {
    @ObservedObject var dataManager: DataManager
    let verbSlug: String
    let targetLanguage: String
    let originLanguage: String

    @State private var currentIndex = 0
    @State private var showingAnswer = false
    @State private var shuffledPhrases: [Phrase] = []

    private var verb: Verb? {
        dataManager.loadVerb(slug: verbSlug, language: targetLanguage)
    }

    private var phrases: [Phrase] {
        shuffledPhrases.isEmpty ? [] : shuffledPhrases
    }

    private var currentPhrase: Phrase? {
        guard currentIndex < phrases.count else { return nil }
        return phrases[currentIndex]
    }

    private var progress: Double {
        guard !phrases.isEmpty else { return 0 }
        return Double(currentIndex + 1) / Double(phrases.count)
    }

    var body: some View {
        VStack(spacing: 0) {
            // Progress bar
            ProgressView(value: progress)
                .tint(.accentColor)
                .padding(.horizontal)

            // Counter
            HStack {
                Text("\(currentIndex + 1) / \(phrases.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                if let phrase = currentPhrase {
                    Text(phrase.tense)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.secondary.opacity(0.2))
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)

            Spacer()

            // Flashcard
            if let phrase = currentPhrase {
                FlashcardView(
                    phrase: phrase,
                    showingAnswer: $showingAnswer
                )
                .padding()
            } else if phrases.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "doc.questionmark")
                        .font(.largeTitle)
                    Text("No phrases available for \(Language.find(originLanguage)?.name ?? originLanguage)")
                        .multilineTextAlignment(.center)
                }
                .foregroundStyle(.secondary)
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.green)
                    Text("Drill complete!")
                        .font(.title2)
                    Button("Start Over") {
                        restartDrill()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }

            Spacer()

            // Navigation buttons
            if !phrases.isEmpty && currentIndex < phrases.count {
                HStack(spacing: 20) {
                    Button {
                        previousPhrase()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .frame(width: 60, height: 60)
                    }
                    .disabled(currentIndex == 0)

                    Button {
                        if showingAnswer {
                            nextPhrase()
                        } else {
                            showingAnswer = true
                        }
                    } label: {
                        Text(showingAnswer ? "Next" : "Show")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                    }
                    .buttonStyle(.borderedProminent)

                    Button {
                        nextPhrase()
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .frame(width: 60, height: 60)
                    }
                    .disabled(currentIndex >= phrases.count - 1)
                }
                .padding()
            }
        }
        .navigationTitle(verb?.name ?? "Drill")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    restartDrill()
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                }
            }
        }
        .onAppear {
            loadPhrases()
        }
    }

    private func loadPhrases() {
        guard let verb = verb,
              let originPhrases = verb.phrases[originLanguage] else {
            shuffledPhrases = []
            return
        }
        shuffledPhrases = originPhrases.shuffled()
        currentIndex = 0
        showingAnswer = false
    }

    private func nextPhrase() {
        if currentIndex < phrases.count - 1 {
            currentIndex += 1
            showingAnswer = false
        } else {
            currentIndex = phrases.count // Show completion
        }
    }

    private func previousPhrase() {
        if currentIndex > 0 {
            currentIndex -= 1
            showingAnswer = false
        }
    }

    private func restartDrill() {
        shuffledPhrases = shuffledPhrases.shuffled()
        currentIndex = 0
        showingAnswer = false
    }
}

struct FlashcardView: View {
    let phrase: Phrase
    @Binding var showingAnswer: Bool

    var body: some View {
        VStack(spacing: 24) {
            // Origin (question)
            Text(phrase.origin)
                .font(.title2)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            // Target (answer)
            if showingAnswer {
                Text(phrase.target)
                    .font(.title2)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.green)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            } else {
                Text("Tap to reveal")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.tertiarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                showingAnswer = true
            }
        }
    }
}
