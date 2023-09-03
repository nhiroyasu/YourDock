import AppKit

func defaultGIFImageData() -> Data {
    let url = Bundle.main.url(forResource: "dock-animation", withExtension: "gif")!
    do {
        let gifData = try Data(contentsOf: url)
        let gifLoopData = try GifLoopConverter().convertLoopGif(gifData: gifData)
        return gifLoopData
    } catch {
        warn(error)
        return Data()
    }
}
