import Cocoa

class CustomizeDockIconWindow: NSWindow {
    init(viewController: CustomizeDockIconViewController) {
        let windowSize = NSSize(width: 487, height: 159)
        let screenFrame = NSScreen.main?.visibleFrame ?? .init(origin: .zero, size: .init(width: windowSize.width / 2.0, height: windowSize.height / 2.0))
        let windowPoint = NSPoint(x: (screenFrame.width / 2.0) - (windowSize.width / 2.0), y: (screenFrame.height / 2.0) - (windowSize.height / 2.0))
        super.init(
            contentRect: .init(origin: windowPoint, size: windowSize),
            styleMask: [.miniaturizable, .closable, .titled],
            backing: .buffered,
            defer: true
        )
        canHide = false
        title = "Your Dock"
        contentViewController = viewController
        dockTile.showsApplicationBadge = false
    }

    deinit {
        info("deinit")
    }
}
