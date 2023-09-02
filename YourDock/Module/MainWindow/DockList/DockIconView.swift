import SwiftUI

struct DockIconView: View {
    let config: DockIconConfig

    func nsImage(gifData: Data?) -> NSImage {
        guard let data = gifData,
              let image = NSImage(data: data) else { return NSImage(size: .zero) }
        return image
    }

    var body: some View {
        switch config {
        case .gif(let config):
            DockIconContentRepresentableView(
                frame: .init(origin: .zero, size: .init(width: 64, height: 64)),
                image: nsImage(gifData: config.gifData),
                backgroundColor: config.backgroundColor
            )
        }
    }
}
