import SwiftUI
import BackgroundTasks
import Heartbeat

@main
struct VerbDrillApp: App {
    init() {
        Heartbeat.ping()
        registerBackgroundTask()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(nil) // Supports both light and dark
        }
    }

    private func registerBackgroundTask() {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: "cc.verb-drill.heartbeat",
            using: nil
        ) { task in
            Heartbeat.ping()
            task.setTaskCompleted(success: true)
            self.scheduleNextHeartbeat()
        }
        scheduleNextHeartbeat()
    }

    private func scheduleNextHeartbeat() {
        let request = BGAppRefreshTaskRequest(identifier: "cc.verb-drill.heartbeat")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 6 * 60 * 60) // 6 hours
        try? BGTaskScheduler.shared.submit(request)
    }
}
