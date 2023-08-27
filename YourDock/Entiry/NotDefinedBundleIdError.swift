import Foundation

struct NotDefinedBundleIdError: LocalizedError {
    var errorDescription: String? {
        return "bundle id isn't defined."
    }
}
