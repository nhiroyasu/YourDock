import AppKit

struct GIFDockIconState {
    var dockId: UUID
    var name: String
    var gifData: Data
    var gifAnimation: Bool
    var backgroundColor: NSColor
}
