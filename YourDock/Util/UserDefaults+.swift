import AppKit

extension UserDefaults {
    enum Keys: String {
        case dockTileInfoArray
        case showingAppDock
        case showingIconOnMenubar
    }

    var dockTileInfoArray: [SavedDockTileInfo] {
        get {
            let jsonDecoder = JSONDecoder()
            do {
                let str = self.string(forKey: Keys.dockTileInfoArray.rawValue)
                if let str, let data = str.data(using: .utf8) {
                    let returnValue = try jsonDecoder.decode([SavedDockTileInfo].self, from: data)
                    return returnValue
                } else {
                    return []
                }
            } catch {
                return []
            }
        }
        set {
            let jsonEncoder = JSONEncoder()
            do {
                let data = try jsonEncoder.encode(newValue)
                self.setValue(String(data: data, encoding: .utf8), forKey: Keys.dockTileInfoArray.rawValue)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    // NOTE: read only.
    @objc dynamic var showingAppDock: Bool {
        bool(forKey: Keys.showingAppDock.rawValue)
    }

    // NOTE: read only.
    @objc dynamic var showingIconOnMenubar: Bool {
        bool(forKey: Keys.showingIconOnMenubar.rawValue)
    }
}
