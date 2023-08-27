import AppKit

class SettingWindow: NSWindow {
    init(viewController: NSViewController) {
        let windowSize = NSSize(width: 244, height: 500)
        let screenFrame = NSScreen.main?.visibleFrame ?? .init(origin: .zero, size: .init(width: windowSize.width / 2.0, height: windowSize.height / 2.0))
        let windowPoint = NSPoint(x: (screenFrame.width / 2.0) - (windowSize.width / 2.0), y: (screenFrame.height / 2.0) - (windowSize.height / 2.0))
        super.init(
            contentRect: .init(origin: windowPoint, size: windowSize),
            styleMask: [.closable, .titled],
            backing: .buffered,
            defer: true
        )
        title = "Setting"
        contentViewController = viewController
    }
}
