import Cocoa
import Combine
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    private var customizeDockIconModulesManager: CustomizeDockIconModulesManager!
    private var mainWindowController: MainWindowController?
    private var showingAppDockObserver: NSKeyValueObservation?
    private var showingIconOnMenubarObserver: NSKeyValueObservation?
    private let migrationUseCase: MigrationUseCase = MigrationInteractor(
        dockIconRepository: DockIconRepositoryImpl(userDefaults: UserDefaults.standard),
        gifDataRepository: GifDataRepositoryImpl(),
        userDefaults: UserDefaults.standard
    )
    private let combinedSubjectContainer: CombinedDockIconsSubjectContainer = .init()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // setup
        migrationUseCase.migrate()
        combinedSubjectContainer.combine()
        setupCustomizeDockIconModulesManager()
        setupObservingUserDefaults()

        // show windows
        showMainWindowControllerAndSetupIfNeeded()
        customizeDockIconModulesManager.startAndRestoreLatestDocks()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        customizeDockIconModulesManager.storeDocks()
    }

    func applicationDidBecomeActive(_ notification: Notification) {
        if !customizeDockIconModulesManager.existVisibleCustomizeDockIconWindow() {
            showMainWindowControllerAndSetupIfNeeded()
        }
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
        return generateAppMenu()
    }

    @objc func didTapAddDockMenuItem() {
        customizeDockIconModulesManager.addNewGIFDockIconModule()
    }

    @objc func didTapOpenToolWindowMenuItem() {
        showMainWindowControllerAndSetupIfNeeded()
    }

    #if DEBUG
    @objc func didTapResetUserDefaultsMenuItem() {
        let appDomain = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
    }
    #endif

    private func setupMenubar() {
        if let button = statusItem.button {
            button.image = NSImage(named: "MenuIcon")
            button.imageScaling = .scaleProportionallyDown
        }
        let menu = generateAppMenu()
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem.menu = menu
    }

    private func generateAppMenu() -> NSMenu {
        let menu = NSMenu()
        #if DEBUG
        menu.addItem(NSMenuItem(title: "DEBUG", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Reset UserDefaults", action: #selector(didTapResetUserDefaultsMenuItem), keyEquivalent: ""))
        menu.addItem(.separator())
        #endif
        menu.addItem(NSMenuItem(title: "Add Dock", action: #selector(didTapAddDockMenuItem), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Open Tool Window", action: #selector(didTapOpenToolWindowMenuItem), keyEquivalent: ""))
        return menu
    }

    private func setupCustomizeDockIconModulesManager() {
        let gifDataRepository = GifDataRepositoryImpl()
        customizeDockIconModulesManager = CustomizeDockIconModulesManager(
            gifDataRepository: gifDataRepository,
            dockIconUseCase: DockIconInteractor(
                dockIconRepository: DockIconRepositoryImpl(userDefaults: UserDefaults.standard),
                gifDataRepository: gifDataRepository
            ),
            dockIconsSubject: combinedSubjectContainer.storedDockIconsSubject,
            appendingDockIconSubject: combinedSubjectContainer.appendingDockIconSubject,
            removingDockIconSubject: combinedSubjectContainer.removingDockIconSubject
        )
    }

    private func showMainWindowControllerAndSetupIfNeeded() {
        if mainWindowController == nil {
            mainWindowController = MainWindowController(
                dockListController: DockListControllerImpl(
                    customizeDockIconModulesModifier: customizeDockIconModulesManager
                ),
                dockIconsSubject: combinedSubjectContainer.storedDockIconsSubject
            )
            mainWindowController?.delegate = self
        }
        mainWindowController?.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)

    }

    private func setupObservingUserDefaults() {
        showingAppDockObserver = UserDefaults.standard.observe(\.showingAppDock, options: [.initial, .new]) { _, value in
            if value.newValue ?? true {
                NSApp.setActivationPolicy(.regular)
            } else {
                NSApp.setActivationPolicy(.accessory)
                NSApp.activate(ignoringOtherApps: true)
            }
        }
        showingIconOnMenubarObserver = UserDefaults.standard.observe(\.showingIconOnMenubar, options: [.initial, .new]) { [weak self] _, value in
            if value.newValue ?? true {
                self?.setupMenubar()
                self?.statusItem.isVisible = true
            } else {
                self?.statusItem.menu = nil
                self?.statusItem.isVisible = false
            }
        }
    }
}

extension AppDelegate: MainWindowControllerDelegate {
    func becomeUselessWindow() {
        mainWindowController = nil
    }
}
