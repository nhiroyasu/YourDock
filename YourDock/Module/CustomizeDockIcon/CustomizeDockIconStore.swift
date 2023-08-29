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
    private var state: CustomizeDockIconState
    private let subject: PassthroughSubject<CustomizeDockIconState, Never>

    init(
        state: CustomizeDockIconState,
        subject: PassthroughSubject<CustomizeDockIconState, Never>
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
        state.gifData = nil
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
