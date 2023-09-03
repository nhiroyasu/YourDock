import AppKit
import Combine

protocol CustomizeDockIconModulesModifier {
    func addNewGIFDockIconModule()
    func editCustomizeDockIconModule(at uuid: UUID)
    func removeCustomizeDockIconModule(at uuid: UUID)
}

class CustomizeDockIconModulesManager: CustomizeDockIconModulesModifier {
    private var preservedModuleContainers: [CustomizeDockIconModuleContainer] = []
    private let gifDataRepository: GifDataRepository
    private let dockIconUseCase: DockIconUseCase
    private let dockIconsSubject: CurrentValueSubject<[DockIcon], Never>
    private let appendingDockIconSubject: PassthroughSubject<DockIcon, Never>
    private let removingDockIconSubject: PassthroughSubject<DockIcon, Never>
    private let gifDockIconStateSubscriber: GIFDockIconStateSubscriber
    private var appendingDockIconCancelation: AnyCancellable?
    private var removingDockIconCancelation: AnyCancellable?

    init(
        gifDataRepository: GifDataRepository,
        dockIconUseCase: DockIconUseCase,
        dockIconsSubject: CurrentValueSubject<[DockIcon], Never>,
        appendingDockIconSubject: PassthroughSubject<DockIcon, Never>,
        removingDockIconSubject: PassthroughSubject<DockIcon, Never>
    ) {
        self.gifDataRepository = gifDataRepository
        self.dockIconUseCase = dockIconUseCase
        self.dockIconsSubject = dockIconsSubject
        self.appendingDockIconSubject = appendingDockIconSubject
        self.removingDockIconSubject = removingDockIconSubject
        self.gifDockIconStateSubscriber = GIFDockIconStateSubscriber(dockIconsSubject: dockIconsSubject)

        appendingDockIconCancelation = appendingDockIconSubject.sink(receiveValue: subscribeAppendingDockIcon(dockIcon:))
        removingDockIconCancelation = removingDockIconSubject.sink(receiveValue: subscribeRemovingDockIcon(dockIcon:))
    }

    func startAndRestoreLatestDocks() {
        let dockIcons = dockIconUseCase.fetch()
        if dockIcons.isEmpty {
            addNewGIFDockIconModule()
        } else {
            dockIcons.forEach(appendingDockIconSubject.send(_:))
        }
        do {
            try gifDataRepository.removeAll()
            info("All of the saved GIF images were deleted.")
        } catch {
            warn(error)
        }
    }

    func storeDocks() {
        dockIconUseCase.save(dockIconsSubject.value)
    }

    func addNewGIFDockIconModule() {
        let dockId = UUID()
        let dockIcon = DockIcon(
            id: dockId,
            name: applicationName(),
            config: .gif(config: GifDockIconConfig(
                gifData: defaultGIFImageData(),
                backgroundColor: .clear
            ))
        )
        appendingDockIconSubject.send(dockIcon)
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

    private func addDockIconModule(from dockIcon: DockIcon) {
        switch dockIcon.config {
        case .gif(let config):
            self.addGIFDockIconModule(
                dockId: dockIcon.id,
                state: GIFDockIconState(
                    dockId: dockIcon.id,
                    name: dockIcon.name,
                    gifData: config.gifData,
                    gifAnimation: true,
                    backgroundColor: config.backgroundColor
                )
            )
        }
    }

    private func addGIFDockIconModule(dockId: UUID, state: GIFDockIconState) {
        let stateSubject = PassthroughSubject<GIFDockIconState, Never>()
        stateSubject.receive(subscriber: gifDockIconStateSubscriber)
        let container = CustomizeDockIconModuleContainer(
            uuid: dockId,
            initialState: state,
            stateSubject: stateSubject,
            becomeUselessHandler: { [weak self] containerUuid in
                guard let self,
                      let targetDockIcon = dockIconsSubject.value.first(where: { $0.id == containerUuid }) else { return }
                removingDockIconSubject.send(targetDockIcon)
            }
        )
        container.showMiniaturizedWindow()
        preservedModuleContainers.append(container)
    }
}

extension CustomizeDockIconModulesManager {
    func subscribeAppendingDockIcon(dockIcon: DockIcon) {
        addDockIconModule(from: dockIcon)
    }

    func subscribeRemovingDockIcon(dockIcon: DockIcon) {
        preservedModuleContainers.removeAll(where: { $0.uuid == dockIcon.id })
    }
}
