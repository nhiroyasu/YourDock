import Foundation
import AppKit

protocol DockIconRepository {
    func save(dockIcons: [SavedDockIcon])
    func save(gifDockIcons: [SavedGIFDockIcon])
    func fetchSavedDockIcon() -> [SavedDockIcon]
    func fetchSavedGifDockIcon() -> [SavedGIFDockIcon]
}

class DockIconRepositoryImpl: DockIconRepository {
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    func save(dockIcons: [SavedDockIcon]) {
        userDefaults.dockIcons = dockIcons
    }

    func save(gifDockIcons: [SavedGIFDockIcon]) {
        userDefaults.gifDockIcons = gifDockIcons
    }

    func fetchSavedDockIcon() -> [SavedDockIcon] {
        return userDefaults.dockIcons
    }

    func fetchSavedGifDockIcon() -> [SavedGIFDockIcon] {
        return userDefaults.gifDockIcons
    }
}
