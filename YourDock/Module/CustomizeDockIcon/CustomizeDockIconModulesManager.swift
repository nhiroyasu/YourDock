import AppKit
import Combine

protocol CustomizeDockIconModulesModifier {
    func addNewCustomizeDockIconModule()
    func editCustomizeDockIconModule(at uuid: UUID)
    func removeCustomizeDockIconModule(at uuid: UUID)
}

class CustomizeDockIconModulesManager: CustomizeDockIconModulesModifier {
    private var preservedModuleContainers: [CustomizeDockIconModuleContainer] {
        didSet {
            moduleContainersSubject.send(preservedModuleContainers)
        }
    }
    private let gifDataRepository: GifDataRepository
    private let dockTileInfoRepository: DockTileInfoRepository
    private let moduleContainersSubject: CurrentValueSubject<[CustomizeDockIconModuleContainer], Never>

    init(
        gifDataRepository: GifDataRepository,
        dockTileInfoRepository: DockTileInfoRepository,
        moduleContainersSubject: CurrentValueSubject<[CustomizeDockIconModuleContainer], Never>
    ) {
        self.preservedModuleContainers = []
        self.gifDataRepository = gifDataRepository
        self.dockTileInfoRepository = dockTileInfoRepository
        self.moduleContainersSubject = moduleContainersSubject
    }

    func startAndRestoreLatestDocks() {
        let savedDockTileInfos = dockTileInfoRepository
            .fetch()
            .compactMap(convertToState(from:))
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
        let savedDockTileInfoList: [SavedDockTileInfo] = preservedModuleContainers.compactMap(generateInfo(from:))
        dockTileInfoRepository.save(savedDockTileInfoList: savedDockTileInfoList)
    }

    func addNewCustomizeDockIconModule() {
        addCustomizeDockIconModule(state: .initializeState)
    }

    func editCustomizeDockIconModule(at uuid: UUID) {
        preservedModuleContainers.first(where: { $0.uuid == uuid })?.showWindow()
    }

    func removeCustomizeDockIconModule(at uuid: UUID) {
        // NOTE: The container containing the window associated with the specified UUID will also be removed from preservedModuleContainers when the window is closed.
        preservedModuleContainers.first(where: { $0.uuid == uuid })?.closeWindow()
    }

    func existVisibleCustomizeDockIconWindow() -> Bool {
        !NSApplication.shared.windows.filter({ ($0 as? CustomizeDockIconWindow)?.isVisible ?? false }).isEmpty
    }

    // MARK: - only used internal

    private func addCustomizeDockIconModule(state: CustomizeDockIconState) {
        let container = CustomizeDockIconModuleContainer(
            initialState: state,
            stateSubscriber: AnySubscriber(self),
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
                name: info.name,
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
                    name: state.name,
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

extension CustomizeDockIconModulesManager: Subscriber {
    typealias Input = CustomizeDockIconState
    typealias Failure = Never

    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }

    func receive(_ input: CustomizeDockIconState) -> Subscribers.Demand {
        moduleContainersSubject.send(preservedModuleContainers)
        return .none
    }

    func receive(completion: Subscribers.Completion<Never>) {}
}
