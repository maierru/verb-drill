import SwiftUI

struct VerbListView: View {
    @ObservedObject var dataManager: DataManager
    @Binding var targetLanguage: String
    @Binding var originLanguage: String
    @State private var showingSettings = false

    private var verbs: [VerbSummary] {
        dataManager.verbs(for: targetLanguage)
    }

    private var languageInfo: LanguageData? {
        dataManager.languageInfo(for: targetLanguage)
    }

    var body: some View {
        List(verbs) { verb in
            NavigationLink {
                DrillView(
                    dataManager: dataManager,
                    verbSlug: verb.slug,
                    targetLanguage: targetLanguage,
                    originLanguage: originLanguage
                )
            } label: {
                VStack(alignment: .leading, spacing: 4) {
                    Text(verb.name)
                        .font(.headline)
                    Text(verb.meaning)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle(languageInfo?.h1 ?? "Verbs")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingSettings = true
                } label: {
                    Image(systemName: "gear")
                }
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView(
                targetLanguage: $targetLanguage,
                originLanguage: $originLanguage,
                availableTargets: dataManager.availableTargetLanguages()
            )
        }
    }
}
