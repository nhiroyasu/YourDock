import AppKit

enum Constants {
    static let githubUrl: URL = URL(string: "https://github.com/nhiroyasu/YourDock")!
    static let githubIcon: NSImage = NSImage(contentsOf: Bundle.main.url(forResource: "github-icon", withExtension: "png")!)!
}
