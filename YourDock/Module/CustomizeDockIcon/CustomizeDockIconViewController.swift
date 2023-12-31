import Cocoa
import Combine

class CustomizeDockIconViewController: NSViewController {

    @IBOutlet private weak var dockIconPreviewView: NSView!
    private var dockIconView: DockIconContentView?
    private var colorObservation: NSKeyValueObservation?
    private let picker = NSColorPanel.shared
    private let stateModifier: CustomizeDockIconStateModifier
    private var preservedState: GIFDockIconState

    init(
        stateModifier: CustomizeDockIconStateModifier,
        initialState: GIFDockIconState
    ) {
        self.stateModifier = stateModifier
        self.preservedState = initialState
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundView = GridBackgroundView(frame: dockIconPreviewView.bounds)
        backgroundView.translatesAutoresizingMaskIntoConstraints = true
        backgroundView.autoresizingMask = [.width, .height]
        dockIconPreviewView.addSubview(backgroundView)
        dockIconPreviewView.wantsLayer = true
        dockIconPreviewView.layer?.backgroundColor = NSColor(red: 0xE0/0xFF, green: 0xE0/0xFF, blue: 0xE0/0xFF, alpha: 1.0).cgColor
        dockIconPreviewView.layer?.borderColor = NSColor(red: 0x77/0xFF, green: 0x77/0xFF, blue: 0x77/0xFF, alpha: 1.0).cgColor
        dockIconPreviewView.layer?.borderWidth = 1
        if let image = NSImage(data: preservedState.gifData) {
            dockIconView = .init(
                frame: .init(origin: .zero, size: dockIconPreviewView.bounds.size),
                image: image,
                backgroundColor: preservedState.backgroundColor
            )
        } else {
            dockIconView = .init(frame: .init(origin: .zero, size: dockIconPreviewView.bounds.size))
        }
        dockIconPreviewView.addSubview(dockIconView!)
    }

    @IBAction func didTapSelectGifButton(_ sender: Any) {
        let openPanel = NSOpenPanel()
        openPanel.title = "Select Gif"
        openPanel.canChooseDirectories = false
        openPanel.allowsMultipleSelection = false
        openPanel.allowedContentTypes = [.gif]
        if openPanel.runModal() == NSApplication.ModalResponse.OK {
            guard let url = openPanel.url else {
                warn("url is nil")
                showWarnAlert(message: "Sorry, Failed to load a file...")
                return
            }
            do {
                let gifData = try Data(contentsOf: url)
                let gifLoopData = try GifLoopConverter().convertLoopGif(gifData: gifData)
                stateModifier.setGifDataAndAnimate(gifLoopData)
                stateModifier.setName(fileName(at: url))
            } catch {
                stateModifier.removeGifData()
                warn(error)
                showWarnAlert(message: "Sorry, Failed to load gif image...")
            }
        }
    }

    @IBAction func didTapColorWell(_ sender: Any) {
        picker.showsAlpha = true
        picker.isContinuous = true
        picker.setTarget(self)
        picker.setAction(#selector(colorDidChange(_:)))
        picker.makeKeyAndOrderFront(nil)
    }

    @IBAction func didTapDockButton(_ sender: Any) {
        view.window?.miniaturize(nil)
    }

    @IBAction func didTapDeleteButton(_ sender: Any) {
        view.window?.performClose(nil)
    }

    @objc func colorDidChange(_ sender: NSColorPanel) {
        stateModifier.setBackgroundColor(sender.color)
    }

    private func showWarnAlert(message: String) {
        let nsAlert = NSAlert()
        nsAlert.alertStyle = .warning
        nsAlert.messageText = message
        nsAlert.runModal()
    }
}

extension CustomizeDockIconViewController: Subscriber {
    typealias Input = GIFDockIconState
    typealias Failure = Never

    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }

    func receive(_ input: GIFDockIconState) -> Subscribers.Demand {
        self.preservedState = input

        // render view based to state.
        dockIconView?.setGif(image: NSImage(data: input.gifData))
        dockIconView?.setAnimates(input.gifAnimation)
        dockIconView?.setBackgroundColor(color: input.backgroundColor)

        return .none
    }

    func receive(completion: Subscribers.Completion<Never>) {}
}
