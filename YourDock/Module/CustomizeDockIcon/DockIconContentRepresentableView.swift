import SwiftUI
import AppKit

struct DockIconContentRepresentableView: NSViewRepresentable {
    typealias NSViewType = DockIconContentView

    let frame: NSRect
    let image: NSImage?
    let backgroundColor: NSColor

    func makeNSView(context: Context) -> DockIconContentView {
        let view = DockIconContentView(frame: frame, image: image, backgroundColor: backgroundColor)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        view.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        return view
    }

    func updateNSView(_ nsView: DockIconContentView, context: Context) {
        nsView.setGif(image: image)
        nsView.setBackgroundColor(color: backgroundColor)
    }

    func sizeThatFits(_ proposal: ProposedViewSize, nsView: DockIconContentView, context: Context) -> CGSize? {
        return frame.size
    }
}
