import Foundation
import AppKit

protocol DockTileInfoRepository {
    func save(savedDockTileInfoList: [SavedDockTileInfo])
    func fetch() -> [SavedDockTileInfo]
}

class DockTileInfoRepositoryImpl: DockTileInfoRepository {
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    func save(savedDockTileInfoList: [SavedDockTileInfo]) {
        userDefaults.savedDockTileInfoList = savedDockTileInfoList
    }

    func fetch() -> [SavedDockTileInfo] {
        if !userDefaults.isFinishedMigrate_v1_0_0_to_v1_1_0 {
            // NOTE: The warning appears, but there is no problem.
            let oldSavedDockTileInfoList = userDefaults.dockTileInfoArray
            let newSavedDockTileInfoList = oldSavedDockTileInfoList.map {
                SavedDockTileInfo(
                    uuid: $0.uuid,
                    name: applicationName(),
                    backgroundColor: NSColor(red: $0.backgroundColorRed, green: $0.backgroundColorGreen, blue: $0.backgroundColorBlue, alpha: $0.backgroundColorAlpha),
                    savedImageFilePath: $0.savedImageFilePath
                )
            }
            // NOTE: The warning appears, but there is no problem.
            userDefaults.dockTileInfoArray = []
            userDefaults.isFinishedMigrate_v1_0_0_to_v1_1_0 = true
            return newSavedDockTileInfoList
        }

        return userDefaults.savedDockTileInfoList
    }
}
