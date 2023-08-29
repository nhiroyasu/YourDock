import Cocoa

class MainWindow: NSWindow {
    init(viewController: NSViewController) {
        let windowSize = NSSize(width: 800, height: 500)
        let windowPoint = NSPoint(x: 200, y: 200)
        super.init(
            contentRect: .init(origin: windowPoint, size: windowSize),
            styleMask: [.closable, .titled],
            backing: .buffered,
            defer: true
        )
        title = "Your Dock!"
        contentViewController = viewController
    }

    deinit {
        info("deinit")
    }
}
