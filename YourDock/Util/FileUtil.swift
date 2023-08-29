import Foundation

func fileName(at url: URL) -> String {
    FileManager.default.displayName(atPath: url.absoluteString).removingPercentEncoding ?? ""
}

func fileName(at path: String) -> String {
    FileManager.default.displayName(atPath: path).removingPercentEncoding ?? ""
}
