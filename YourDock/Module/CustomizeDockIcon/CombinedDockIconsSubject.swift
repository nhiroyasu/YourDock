import Combine

class CombinedDockIconsSubjectContainer {
    let storedDockIconsSubject: CurrentValueSubject<[DockIcon], Never> = .init([])
    let appendingDockIconSubject: PassthroughSubject<DockIcon, Never> = .init()
    let removingDockIconSubject: PassthroughSubject<DockIcon, Never> = .init()
    let editingDockIconSubject: PassthroughSubject<DockIcon, Never> = .init()

    private var appendingDockIconCancelation: AnyCancellable?
    private var removingDockIconCancelation: AnyCancellable?
    private var editingDockIconCancelation: AnyCancellable?

    func combine() {
        appendingDockIconCancelation = appendingDockIconSubject.sink { [weak self] dockIcon in
            guard let self else { return }
            var newDockIcons = self.storedDockIconsSubject.value
            newDockIcons.append(dockIcon)
            self.storedDockIconsSubject.send(newDockIcons)
        }

        removingDockIconCancelation = removingDockIconSubject.sink { [weak self] dockIcon in
            guard let self else { return }
            var newDockIcons = self.storedDockIconsSubject.value
            newDockIcons.removeAll(where: { $0.id == dockIcon.id })
            self.storedDockIconsSubject.send(newDockIcons)
        }

        editingDockIconCancelation = editingDockIconSubject.sink { [weak self] dockIcon in
            guard let self else { return }
            var newDockIcons = self.storedDockIconsSubject.value
            if let replacingIndex = newDockIcons.firstIndex(where: { $0.id == dockIcon.id }) {
                newDockIcons[replacingIndex] = dockIcon
                self.storedDockIconsSubject.send(newDockIcons)
            }
        }
    }
}
