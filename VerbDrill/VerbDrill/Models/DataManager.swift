import Foundation

@MainActor
class DataManager: ObservableObject {
    @Published var verbData: VerbData?
    @Published var isLoading = true
    @Published var error: String?

    private var verbCache: [String: Verb] = [:]

    init() {
        loadData()
    }

    private func loadData() {
        guard let url = Bundle.main.url(forResource: "data", withExtension: "json") else {
            error = "Data file not found"
            isLoading = false
            return
        }

        do {
            let data = try Data(contentsOf: url)
            verbData = try JSONDecoder().decode(VerbData.self, from: data)
            isLoading = false
        } catch {
            self.error = "Failed to load data: \(error.localizedDescription)"
            isLoading = false
        }
    }

    func verbs(for language: String) -> [VerbSummary] {
        verbData?.languages[language]?.verbs ?? []
    }

    func languageInfo(for code: String) -> LanguageData? {
        verbData?.languages[code]
    }

    func availableTargetLanguages() -> [String] {
        guard let languages = verbData?.languages else { return [] }
        return Array(languages.keys).sorted()
    }

    func loadVerb(slug: String, language: String) -> Verb? {
        let cacheKey = "\(language)/\(slug)"
        if let cached = verbCache[cacheKey] {
            return cached
        }

        guard let url = Bundle.main.url(forResource: "\(language)_\(slug)", withExtension: "json") else {
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let verb = try JSONDecoder().decode(Verb.self, from: data)
            verbCache[cacheKey] = verb
            return verb
        } catch {
            print("Failed to load verb: \(error)")
            return nil
        }
    }

    func availableOriginLanguages(for verb: Verb) -> [String] {
        Array(verb.phrases.keys).sorted()
    }
}
