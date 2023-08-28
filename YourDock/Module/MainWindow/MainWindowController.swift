import Cocoa
import SwiftUI
import Combine

protocol MainWindowControllerDelegate: AnyObject {
    func becomeUselessWindow()
}

class MainWindowController: NSWindowController, NSWindowDelegate {
    private let viewController: NSHostingController<MainView>
    weak var delegate: MainWindowControllerDelegate!

    init(
        dockListController: DockListController,
        moduleContainersSubject: CurrentValueSubject<[CustomizeDockIconModuleContainer], Never>
    ) {
        self.viewController = NSHostingController<MainView>(
            rootView: MainView(
                dockListController: dockListController,
                moduleContainersSubject: moduleContainersSubject
            )
        )
        let window = MainWindow(viewController: viewController)
        super.init(window: window)
        window.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func windowDidLoad() {
        super.windowDidLoad()
    }

    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        delegate.becomeUselessWindow()
        return true
    }

    func showWindowAtCenter(_ sender: Any?) {
        showWindow(sender)
        let screenSize = NSScreen.main?.frame.size ?? .init(width: 500, height: 500)
        let windowSize = window?.frame.size ?? .init(width: 500, height: 500)
        window?.setFrameOrigin(NSPoint(x: screenSize.width / 2.0 - windowSize.width / 2.0, y: screenSize.height / 2.0 - windowSize.height / 2.0))
    }
}
