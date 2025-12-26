import Foundation

struct VerbData: Codable {
    let languages: [String: LanguageData]
}

struct LanguageData: Codable {
    let title: String
    let h1: String
    let subtitle: String
    let verbs: [VerbSummary]
}

struct VerbSummary: Codable, Identifiable {
    let name: String
    let meaning: String
    let slug: String

    var id: String { slug }
}

struct Verb: Codable {
    let slug: String
    let name: String
    let meaning: String
    let verbForms: [String]?
    let phrases: [String: [Phrase]]

    enum CodingKeys: String, CodingKey {
        case slug, name, meaning
        case verbForms = "verb_forms"
        case phrases
    }
}

struct Phrase: Codable, Identifiable {
    let origin: String
    let target: String
    let tense: String

    var id: String { "\(origin)-\(target)" }
}

// Language configuration
struct Language: Identifiable {
    let code: String
    let name: String
    let flag: String

    var id: String { code }

    var displayName: String { "\(flag) \(name)" }
}

extension Language {
    static let all: [Language] = [
        Language(code: "pt-eu", name: "Portuguese", flag: "🇵🇹"),
        Language(code: "en", name: "English", flag: "🇬🇧"),
        Language(code: "es", name: "Spanish", flag: "🇪🇸"),
        Language(code: "de", name: "German", flag: "🇩🇪"),
        Language(code: "fr", name: "French", flag: "🇫🇷"),
        Language(code: "ru", name: "Russian", flag: "🇷🇺"),
        Language(code: "pt", name: "Portuguese (BR)", flag: "🇧🇷"),
    ]

    static func find(_ code: String) -> Language? {
        all.first { $0.code == code }
    }
}
