import Combine

class GIFDockIconStateSubscriber: Subscriber {
    typealias Input = GIFDockIconState
    typealias Failure = Never

    private let dockIconsSubject: CurrentValueSubject<[DockIcon], Never>

    init(dockIconsSubject: CurrentValueSubject<[DockIcon], Never>) {
        self.dockIconsSubject = dockIconsSubject
    }

    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }

    func receive(_ input: Input) -> Subscribers.Demand {
        var newDockIcons = dockIconsSubject.value
        if let modifiedDockIconIndex = newDockIcons.firstIndex(where: { $0.id == input.dockId }) {
            newDockIcons[modifiedDockIconIndex] = DockIcon(
                id: input.dockId,
                name: input.name,
                config: .gif(config: GifDockIconConfig(
                    gifData: input.gifData,
                    backgroundColor: input.backgroundColor)
                )
            )
            dockIconsSubject.send(newDockIcons)
        }
        return .none
    }

    func receive(completion: Subscribers.Completion<Never>) {}
}
