import AppKit

struct CustomizeDockIconState {
    var gifData: Data?
    var name: String
    var gifAnimation: Bool
    var backgroundColor: NSColor

    static let initializeState: CustomizeDockIconState = {
        let url = Bundle.main.url(forResource: "dock-animation", withExtension: "gif")!
        let gifData = (try? Data(contentsOf: url)) ?? Data()
        let gifLoopData = (try? GifLoopConverter().convertLoopGif(gifData: gifData)) ?? nil
        return CustomizeDockIconState(
            gifData: gifLoopData,
            name: applicationName(),
            gifAnimation: true,
            backgroundColor: .clear
        )
    }()
}
