import AppKit

class DockIconContentView: NSView {
    private let imageView: NSImageView

    override convenience init(frame frameRect: NSRect) {
        self.init(frame: frameRect, image: nil, backgroundColor: .clear)
    }

    init(
        frame frameRect: NSRect,
        image: NSImage?,
        backgroundColor: NSColor
    ) {
        imageView = AntialiasedImageView(frame: .zero)
        super.init(frame: frameRect)
        wantsLayer = true
        translatesAutoresizingMaskIntoConstraints = true
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.animates = true
        imageView.wantsLayer = true
        imageView.image = image
        layer?.masksToBounds = true
        layer?.cornerRadius = frameRect.width * 0.2
        layer?.backgroundColor = backgroundColor.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setGif(image: NSImage?) {
        imageView.image = image
    }

    func setBackgroundColor(color: NSColor) {
        layer?.backgroundColor = color.cgColor
    }

    func setAnimates(_ flag: Bool) {
        imageView.animates = flag
    }
}
