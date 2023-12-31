import AppKit
import Combine

class CustomizeDockIconModuleContainer {
    let uuid: UUID
    private let windowController: CustomizeDockIconWindowController
    private let window: CustomizeDockIconWindow
    private let viewController: CustomizeDockIconViewController
    private let stateSubject: PassthroughSubject<GIFDockIconState, Never>
    private let stateModifier: CustomizeDockIconStateModifier
    private let becomeUselessHandler: (_ containerUuid: UUID) -> Void

    private(set) var preservedState: GIFDockIconState

    init(
        uuid: UUID,
        initialState: GIFDockIconState,
        stateSubject: PassthroughSubject<GIFDockIconState, Never>,
        becomeUselessHandler: @escaping (_ containerUuid: UUID) -> Void
    ) {
        self.uuid = uuid
        self.preservedState = initialState
        self.stateSubject = stateSubject
        self.stateModifier = CustomizeDockIconStore(
            state: initialState,
            subject: stateSubject
        )
        self.becomeUselessHandler = becomeUselessHandler
        self.viewController = CustomizeDockIconViewController(
            stateModifier: stateModifier,
            initialState: initialState
        )
        self.window = CustomizeDockIconWindow(viewController: viewController)
        self.windowController = CustomizeDockIconWindowController(
            window: window,
            stateModifier: stateModifier,
            initialState: initialState
        )
        self.windowController.delegate = self
        stateSubject.receive(subscriber: windowController)
        stateSubject.receive(subscriber: viewController)
        stateSubject.receive(subscriber: self)
    }

    deinit {
        info("deinit")
    }

    func showWindow() {
        windowController.showWindow(self)
    }

    func showMiniaturizedWindow() {
        window.miniaturize(self)
    }

    func closeWindow() {
        window.performClose(self)
    }
}

extension CustomizeDockIconModuleContainer: Subscriber {
    typealias Input = GIFDockIconState
    typealias Failure = Never

    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }

    func receive(_ input: GIFDockIconState) -> Subscribers.Demand {
        self.preservedState = input
        return .none
    }

    func receive(completion: Subscribers.Completion<Never>) {}
}

extension CustomizeDockIconModuleContainer: CustomizeDockIconWindowControllerDelegate {
    func onCloseWindow() {
        stateSubject.send(completion: .finished)
        becomeUselessHandler(uuid)
    }
}
