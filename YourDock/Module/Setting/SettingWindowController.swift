import Cocoa

class SettingWindowController: NSWindowController {
    private let viewController: SettingViewController

    init() {
        self.viewController = SettingViewController()
        let window = SettingWindow(viewController: viewController)
        super.init(window: window)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func windowDidLoad() {
        super.windowDidLoad()
    
    }
}
