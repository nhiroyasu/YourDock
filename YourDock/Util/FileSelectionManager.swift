import AppKit
import UniformTypeIdentifiers

enum FileType {
    case image
    case movie
    case gif
    case none

    var extensionList: [String] {
        switch self {
        case .image:
            return ["jpg", "jpeg", "JPG", "JPEG", "png", "PNG", "tiff", "TIFF", "tif", "TIF"]
        case .movie:
            return ["mp4", "mov"]
        case .gif:
            return ["gif"]
        case .none:
            return []
        }
    }
}

protocol FileSelectionManager {
    func open(fileType: FileType) -> URL?
}

class FileSelectionManagerImpl: FileSelectionManager {
    func open(fileType: FileType) -> URL? {
        let openPanel = NSOpenPanel()
        openPanel.title = "Select"
        openPanel.canChooseDirectories = false
        openPanel.allowsMultipleSelection = false
        openPanel.allowedContentTypes = [.gif]
        if openPanel.runModal() == NSApplication.ModalResponse.OK {
            return openPanel.url
        } else {
            return nil
        }
    }
}
