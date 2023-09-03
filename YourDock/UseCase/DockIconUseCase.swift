import Foundation
import AppKit

protocol DockIconUseCase {
    func save(_ dockIcons: [DockIcon])
    func fetch() -> [DockIcon]
}

class DockIconInteractor: DockIconUseCase {
    private let dockIconRepository: DockIconRepository
    private let gifDataRepository: GifDataRepository

    init(dockIconRepository: DockIconRepository, gifDataRepository: GifDataRepository) {
        self.dockIconRepository = dockIconRepository
        self.gifDataRepository = gifDataRepository
    }

    func save(_ dockIcons: [DockIcon]) {
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

    func fetch() -> [DockIcon] {
        let savedDockIcons = dockIconRepository.fetchSavedDockIcon()
        let dockIcons = savedDockIcons.compactMap { [weak self] (savedDockIcon: SavedDockIcon) -> DockIcon? in
            guard let self else { return nil }
            switch savedDockIcon.type {
            case .gif:
                do {
                    let gifData = try self.gifDataRepository.read(name: savedDockIcon.uuid.uuidString)
                    if let savedGIFDockIcon = self.dockIconRepository
                        .fetchSavedGifDockIcon()
                        .first(where: { $0.uuid == savedDockIcon.uuid }) {
                        return DockIcon(
                            id: savedDockIcon.uuid,
                            name: savedDockIcon.name,
                            config: .gif(config: GifDockIconConfig(
                                gifData: gifData,
                                backgroundColor: NSColor(
                                    red: savedGIFDockIcon.backgroundColorRed,
                                    green: savedGIFDockIcon.backgroundColorGreen,
                                    blue: savedGIFDockIcon.backgroundColorBlue,
                                    alpha: savedGIFDockIcon.backgroundColorAlpha
                                )
                            ))
                        )
                    } else {
                        return nil
                    }

                } catch {
                    warn(error)
                    return nil
                }
            }
        }
        return dockIcons
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
