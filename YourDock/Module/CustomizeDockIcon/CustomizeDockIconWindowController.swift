import Cocoa
import Combine

protocol CustomizeDockIconWindowControllerDelegate: AnyObject {
    func onCloseWindow()
}

class CustomizeDockIconWindowController: NSWindowController, NSWindowDelegate {
    private let stateModifier: CustomizeDockIconStateModifier
    private var preservedState: CustomizeDockIconState

    private let dockTileAnimationQueue = DispatchQueue.main
    private var dockTileAnimationQueueCancellation: Cancellable?

    weak var delegate: CustomizeDockIconWindowControllerDelegate!

    init(
        window: NSWindow,
        stateModifier: CustomizeDockIconStateModifier,
        initialState: CustomizeDockIconState
    ) {
        self.stateModifier = stateModifier
        self.preservedState = initialState
        super.init(window: window)
        window.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        info("deinit")
    }

    override func windowDidLoad() {
        super.windowDidLoad()
    }

    func windowWillMiniaturize(_ notification: Notification) {
        stateModifier.pauseAnimation()
        window?.dockTile.contentView = generateDockTileContentView(state: preservedState)

        dockTileAnimationQueueCancellation = dockTileAnimationQueue.schedule(
            after: .init(.now()),
            interval: .milliseconds(33),
            tolerance: .milliseconds(10),
            options: nil
        ) { [weak self] in
            self?.window?.dockTile.display()
        }
    }

    func windowDidDeminiaturize(_ notification: Notification) {
        stateModifier.startAnimation()
        dockTileAnimationQueueCancellation?.cancel()
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        delegate.onCloseWindow()
        return true
    }

    private func generateDockTileContentView(state: CustomizeDockIconState) -> NSView? {
        guard let window,
              let gifData = state.gifData,
              let image = NSImage(data: gifData) else {
            return nil
        }
        let dockTileContentView = DockIconContentView(
            frame: .init(origin: .zero, size: window.dockTile.size),
            image: image,
            backgroundColor: state.backgroundColor
        )
        return dockTileContentView
    }
}

extension CustomizeDockIconWindowController: Subscriber {
    typealias Input = CustomizeDockIconState
    typealias Failure = Never

    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }

    func receive(_ input: CustomizeDockIconState) -> Subscribers.Demand {
        self.preservedState = input
        return .none
    }

    func receive(completion: Subscribers.Completion<Never>) {}
}
