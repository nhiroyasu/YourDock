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
        dockIconsSubject: CurrentValueSubject<[DockIcon], Never>
    ) {
        self.viewController = NSHostingController<MainView>(
            rootView: MainView(
                dockListController: dockListController,
                dockIconsSubject: dockIconsSubject
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
}
