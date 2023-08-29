import AppKit

extension UserDefaults {
    enum Keys: String {
        case dockTileInfoArray
        case savedDockTileInfoList
        case showingAppDock
        case showingIconOnMenubar
        case isFinishedMigrate_v1_0_0_to_v1_1_0
    }

    // NOTE: This property is only used in v1.0.0
    @available(*, deprecated, message: "Use savedDockTileInfoList")
    var dockTileInfoArray: [SavedDockTileInfo_V1_0_0] {
        get {
            let jsonDecoder = JSONDecoder()
            do {
                let str = self.string(forKey: Keys.dockTileInfoArray.rawValue)
                if let str, let data = str.data(using: .utf8) {
                    let returnValue = try jsonDecoder.decode([SavedDockTileInfo_V1_0_0].self, from: data)
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
                err(error.localizedDescription)
            }
        }
    }

    var savedDockTileInfoList: [SavedDockTileInfo] {
        get {
            let jsonDecoder = JSONDecoder()
            do {
                let str = self.string(forKey: Keys.savedDockTileInfoList.rawValue)
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
                self.setValue(String(data: data, encoding: .utf8), forKey: Keys.savedDockTileInfoList.rawValue)
            } catch {
                err(error.localizedDescription)
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

    var isFinishedMigrate_v1_0_0_to_v1_1_0: Bool {
        get {
            bool(forKey: Keys.isFinishedMigrate_v1_0_0_to_v1_1_0.rawValue)
        }
        set {
            setValue(newValue, forKey: Keys.isFinishedMigrate_v1_0_0_to_v1_1_0.rawValue)
        }
    }
}
