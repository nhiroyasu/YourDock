import AppKit

class CustomizeDockIconModulesManager {
    private var preservedModuleContainers: [CustomizeDockIconModuleContainer]
    private let gifDataRepository: GifDataRepository
    private var userDefaults: UserDefaults

    init(gifDataRepository: GifDataRepository) {
        self.preservedModuleContainers = []
        self.gifDataRepository = gifDataRepository
        self.userDefaults = UserDefaults.standard
    }

    func startAndRestoreLatestDocks() {
        let savedDockTileInfos = userDefaults.dockTileInfoArray.compactMap(convertToState(from:))
        if savedDockTileInfos.isEmpty {
            addNewCustomizeDockIconModule()
            do {
                try gifDataRepository.removeAll()
            } catch {
                warn(error)
            }
        } else {
            savedDockTileInfos.forEach(addCustomizeDockIconModule(state:))
        }
    }

    func storeDocks() {
        let savedDockTileInfoArray: [SavedDockTileInfo] = preservedModuleContainers.compactMap(generateInfo(from:))
        userDefaults.dockTileInfoArray = savedDockTileInfoArray
    }

    func addNewCustomizeDockIconModule() {
        addCustomizeDockIconModule(state: .initializeState)
    }

    // MARK: - only used internal

    private func addCustomizeDockIconModule(state: CustomizeDockIconState) {
        let container = CustomizeDockIconModuleContainer(
            initialState: state,
            becomeUselessHandler: { [weak self] containerUuid in
                self?.preservedModuleContainers.removeAll(where: { $0.uuid == containerUuid })
            }
        )
        container.showMiniaturizedWindow()
        preservedModuleContainers.append(container)
    }

    private func convertToState(from info: SavedDockTileInfo) -> CustomizeDockIconState? {
        do {
            let data = try gifDataRepository.read(name: info.uuid.uuidString)
            try gifDataRepository.remove(name: info.uuid.uuidString)
            return CustomizeDockIconState(
                gifData: data,
                gifAnimation: true,
                backgroundColor: NSColor(red: info.backgroundColorRed, green: info.backgroundColorGreen, blue: info.backgroundColorBlue, alpha: info.backgroundColorAlpha)
            )
        } catch {
            warn(error)
            return nil
        }
    }

    private func generateInfo(from container: CustomizeDockIconModuleContainer) -> SavedDockTileInfo? {
        let state = container.preservedState
        let uuid = container.uuid
        if let data = state.gifData {
            do {
                let url = try gifDataRepository.write(name: uuid.uuidString, gifData: data)
                return .init(
                    uuid: uuid,
                    backgroundColor: state.backgroundColor,
                    savedImageFilePath: url
                )
            } catch {
                warn(error)
                return nil
            }
        } else {
            return nil
        }
    }
}
