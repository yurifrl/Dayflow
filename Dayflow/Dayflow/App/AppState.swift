import SwiftUI
import Combine

@MainActor // <--- Add this
protocol AppStateManaging: ObservableObject {
    // This requirement must now be fulfilled on the main actor
    var isRecording: Bool { get }
    var objectWillChange: ObservableObjectPublisher { get }
}

@MainActor
final class AppState: ObservableObject, AppStateManaging { // <-- Add AppStateManaging here
    static let shared = AppState()
    @Published var isRecording = true {
        didSet {
            print("[AppState] isRecording changed: \(oldValue) -> \(isRecording)")
        }
    }
    private init() {}
}
