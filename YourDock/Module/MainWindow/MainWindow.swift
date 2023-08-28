import Cocoa

class MainWindow: NSWindow {
    init(viewController: NSViewController) {
        let windowSize = NSSize(width: 800, height: 500)
        let windowPoint = NSPoint.zero
        super.init(
            contentRect: .init(origin: windowPoint, size: windowSize),
            styleMask: [.closable, .titled],
            backing: .buffered,
            defer: true
        )
        title = "Your Dock!"
        contentViewController = viewController
    }
}
