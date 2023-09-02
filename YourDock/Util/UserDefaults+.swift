import AppKit

extension UserDefaults {
    enum Keys: String {
        // stored data keys
        case dockTileInfoArray // deprecated
        case savedDockTileInfoList // deprecated
        case dockIcons
        case gifDockIcons
        // configuration keys
        case showingAppDock
        case showingIconOnMenubar
        case isFinishedMigrate_v1_0_0_to_v1_1_0
        case isFinishedMigrate_for_v1_2_0
    }

    // NOTE: This property is only used in v1.0.0
    @available(*, deprecated, message: "Use dockIcons")
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

    // NOTE: This property is only used in v1.1.0
    @available(*, deprecated, message: "Use dockIcons")
    var savedDockTileInfoList: [SavedDockTileInfo_V1_1_0] {
        get {
            let jsonDecoder = JSONDecoder()
            do {
                let str = self.string(forKey: Keys.savedDockTileInfoList.rawValue)
                if let str, let data = str.data(using: .utf8) {
                    let returnValue = try jsonDecoder.decode([SavedDockTileInfo_V1_1_0].self, from: data)
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

    var dockIcons: [SavedDockIcon] {
        get {
            let jsonDecoder = JSONDecoder()
            do {
                let str = self.string(forKey: Keys.dockIcons.rawValue)
                if let str, let data = str.data(using: .utf8) {
                    return try jsonDecoder.decode([SavedDockIcon].self, from: data)
                } else {
                    return []
                }
            } catch {
                err(error)
                return []
            }
        }
        set {
            let jsonEncoder = JSONEncoder()
            do {
                let data = try jsonEncoder.encode(newValue)
                self.setValue(String(data: data, encoding: .utf8), forKey: Keys.dockIcons.rawValue)
            } catch {
                err(error.localizedDescription)
            }
        }
    }

    // NOTE: related 'dockIcons' data
    var gifDockIcons: [SavedGIFDockIcon] {
        get {
            let jsonDecoder = JSONDecoder()
            do {
                let str = self.string(forKey: Keys.gifDockIcons.rawValue)
                if let str, let data = str.data(using: .utf8) {
                    return try jsonDecoder.decode([SavedGIFDockIcon].self, from: data)
                } else {
                    return []
                }
            } catch {
                err(error)
                return []
            }
        }
        set {
            let jsonEncoder = JSONEncoder()
            do {
                let data = try jsonEncoder.encode(newValue)
                self.setValue(String(data: data, encoding: .utf8), forKey: Keys.gifDockIcons.rawValue)
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

    var isFinishedMigrate_for_v1_2_0: Bool {
        get {
            bool(forKey: Keys.isFinishedMigrate_for_v1_2_0.rawValue)
        }
        set {
            setValue(newValue, forKey: Keys.isFinishedMigrate_for_v1_2_0.rawValue)
        }
    }
}
