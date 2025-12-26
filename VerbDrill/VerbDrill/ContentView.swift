import SwiftUI

struct ContentView: View {
    @StateObject private var dataManager = DataManager()
    @AppStorage("targetLanguage") private var targetLanguage = "pt-eu"
    @AppStorage("originLanguage") private var originLanguage = "en"

    var body: some View {
        NavigationStack {
            if dataManager.isLoading {
                ProgressView("Loading...")
            } else if let error = dataManager.error {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                    Text(error)
                        .multilineTextAlignment(.center)
                }
                .padding()
            } else {
                VerbListView(
                    dataManager: dataManager,
                    targetLanguage: $targetLanguage,
                    originLanguage: $originLanguage
                )
            }
        }
    }
}

#Preview {
    ContentView()
}
