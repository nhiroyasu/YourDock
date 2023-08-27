import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    private let customizeDockIconModulesManager = CustomizeDockIconModulesManager(
        gifDataRepository: GifDataRepositoryImpl()
    )
    private var settingWindowController: SettingWindowController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        setupMenu()
        customizeDockIconModulesManager.startAndRestoreLatestDocks()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        customizeDockIconModulesManager.storeDocks()
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    @objc func didTapAddDockMenuItem() {
        customizeDockIconModulesManager.addNewCustomizeDockIconModule()
    }

    @objc func didTapSettingMenuItem () {
        if settingWindowController == nil {
            settingWindowController = .init()
        }
        settingWindowController?.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    private func setupMenu() {
        if let button = statusItem.button {
            button.image = NSImage(named: "MenuIcon")
            button.imageScaling = .scaleProportionallyDown
        }
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Add Dock", action: #selector(didTapAddDockMenuItem), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Setting", action: #selector(didTapSettingMenuItem), keyEquivalent: ""))
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem.menu = menu
    }
}
