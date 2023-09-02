import Foundation
import AppKit

protocol MigrationUseCase {
    func migrate()
}

class MigrationInteractor: MigrationUseCase {
    private let dockIconRepository: DockIconRepository
    private let gifDataRepository: GifDataRepository
    private let userDefaults: UserDefaults

    init(dockIconRepository: DockIconRepository, gifDataRepository: GifDataRepository, userDefaults: UserDefaults) {
        self.dockIconRepository = dockIconRepository
        self.gifDataRepository = gifDataRepository
        self.userDefaults = userDefaults
    }

    func migrate() {
        guard !userDefaults.isFinishedMigrate_for_v1_2_0 else { return }

        // NOTE: The warning appears, but there is no problem.
        if !userDefaults.dockTileInfoArray.isEmpty {
            let oldSavedDockTileInfoList = userDefaults.dockTileInfoArray
            let newDockIcons = oldSavedDockTileInfoList.compactMap { (oldSavedDockTileInfo: SavedDockTileInfo_V1_0_0) -> DockIcon? in
                do {
                    let gifData = try gifDataRepository.read(name: oldSavedDockTileInfo.uuid.uuidString)
                    return DockIcon(
                        id: oldSavedDockTileInfo.uuid,
                        name: applicationName(),
                        config: .gif(config: GifDockIconConfig(
                            gifData: gifData,
                            backgroundColor: NSColor(
                                red: oldSavedDockTileInfo.backgroundColorRed,
                                green: oldSavedDockTileInfo.backgroundColorGreen,
                                blue: oldSavedDockTileInfo.backgroundColorBlue,
                                alpha: oldSavedDockTileInfo.backgroundColorAlpha
                            )
                        ))
                    )
                } catch {
                    warn(error)
                    return nil
                }
            }
            save(newDockIcons)
            userDefaults.dockTileInfoArray = []
        }
        if !userDefaults.savedDockTileInfoList.isEmpty {
            let oldSavedDockTileInfoList = userDefaults.savedDockTileInfoList
            let newDockIcons = oldSavedDockTileInfoList.compactMap { (oldSavedDockTileInfo: SavedDockTileInfo_V1_1_0) -> DockIcon? in
                do {
                    let gifData = try gifDataRepository.read(name: oldSavedDockTileInfo.uuid.uuidString)
                    return DockIcon(
                        id: oldSavedDockTileInfo.uuid,
                        name: oldSavedDockTileInfo.name,
                        config: .gif(config: GifDockIconConfig(
                            gifData: gifData,
                            backgroundColor: NSColor(
                                red: oldSavedDockTileInfo.backgroundColorRed,
                                green: oldSavedDockTileInfo.backgroundColorGreen,
                                blue: oldSavedDockTileInfo.backgroundColorBlue,
                                alpha: oldSavedDockTileInfo.backgroundColorAlpha
                            )
                        ))
                    )
                } catch {
                    warn(error)
                    return nil
                }
            }
            save(newDockIcons)
            userDefaults.savedDockTileInfoList = []
        }
        userDefaults.isFinishedMigrate_for_v1_2_0 = true
    }

    private func save(_ dockIcons: [DockIcon]) {
        let savedDockIcons = dockIcons.map(convertSavedDockIcon(from:))
        dockIconRepository.save(dockIcons: savedDockIcons)
        let savedGIFDockIcons = dockIcons.compactMap { [weak self] (dockIcon: DockIcon) -> SavedGIFDockIcon? in
            guard let self else { return nil }
            if case .gif(let config) = dockIcon.config {
                do {
                    let url = try self.gifDataRepository.write(name: dockIcon.id.uuidString, gifData: config.gifData)
                    return SavedGIFDockIcon(
                        uuid: dockIcon.id,
                        savedImageFilePath: url,
                        backgroundColor: config.backgroundColor
                    )
                } catch {
                    warn(error)
                    return nil
                }
            } else {
                return nil
            }
        }
        dockIconRepository.save(gifDockIcons: savedGIFDockIcons)
    }

    private func convertSavedDockIcon(from dockIcon: DockIcon) -> SavedDockIcon {
        let type: SavedDockIconType
        switch dockIcon.config {
        case .gif:
            type = .gif
        }
        return SavedDockIcon(
            uuid: dockIcon.id,
            name: dockIcon.name,
            type: type
        )
    }
}
