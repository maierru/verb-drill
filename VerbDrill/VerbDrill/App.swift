import SwiftUI
import Heartbeat

@main
struct VerbDrillApp: App {
    init() {
        Heartbeat.start()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(nil) // Supports both light and dark
        }
    }
}
