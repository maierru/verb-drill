import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var targetLanguage: String
    @Binding var originLanguage: String
    let availableTargets: [String]

    private var targetLanguages: [Language] {
        availableTargets.compactMap { Language.find($0) }
    }

    private var originLanguages: [Language] {
        Language.all.filter { $0.code != targetLanguage }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("I want to learn") {
                    Picker("Target Language", selection: $targetLanguage) {
                        ForEach(targetLanguages) { lang in
                            Text(lang.displayName).tag(lang.code)
                        }
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                }

                Section("I speak") {
                    Picker("Origin Language", selection: $originLanguage) {
                        ForEach(originLanguages) { lang in
                            Text(lang.displayName).tag(lang.code)
                        }
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
