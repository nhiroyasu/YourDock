import Foundation

struct GifFormatError: LocalizedError {
    var errorDescription: String? {
        return "invalid gif data."
    }
}
