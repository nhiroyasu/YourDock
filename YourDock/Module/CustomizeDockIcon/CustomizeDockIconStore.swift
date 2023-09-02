import AppKit
import Combine

protocol CustomizeDockIconStateModifier {
    func setGifDataAndAnimate(_ data: Data)
    func setName(_ name: String)
    func removeGifData()
    func startAnimation()
    func pauseAnimation()
    func setBackgroundColor(_ color: NSColor)
}

class CustomizeDockIconStore: CustomizeDockIconStateModifier {
    private var state: GIFDockIconState
    private let subject: PassthroughSubject<GIFDockIconState, Never>

    init(
        state: GIFDockIconState,
        subject: PassthroughSubject<GIFDockIconState, Never>
    ) {
        self.state = state
        self.subject = subject
    }

    func setGifDataAndAnimate(_ data: Data) {
        state.gifData = data
        state.gifAnimation = true
        subject.send(state)
    }

    func setName(_ name: String) {
        state.name = name
        subject.send(state)
    }

    func removeGifData() {
        state.gifData = defaultGIFImageData()
        subject.send(state)
    }

    func startAnimation() {
        state.gifAnimation = true
        subject.send(state)
    }

    func pauseAnimation() {
        state.gifAnimation = false
        subject.send(state)
    }

    func setBackgroundColor(_ color: NSColor) {
        state.backgroundColor = color
        subject.send(state)
    }
}
