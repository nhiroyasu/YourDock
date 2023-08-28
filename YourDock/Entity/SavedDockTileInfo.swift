import AppKit

struct SavedDockTileInfo: Codable {
    let uuid: UUID
    let name: String
    let backgroundColorRed: Double
    let backgroundColorGreen: Double
    let backgroundColorBlue: Double
    let backgroundColorAlpha: Double
    let savedImageFilePath: URL

    init(
        uuid: UUID,
        name: String,
        backgroundColor: NSColor,
        savedImageFilePath: URL
    ) {
        self.uuid = uuid
        self.name = name
        self.savedImageFilePath = savedImageFilePath
        if let cgColor = backgroundColor.cgColor.converted(to: CGColorSpace(name: CGColorSpace.sRGB)!, intent: CGColorRenderingIntent.defaultIntent, options: nil) {
            self.backgroundColorRed = Double(cgColor.components?[0] ?? 0)
            self.backgroundColorGreen = Double(cgColor.components?[1] ?? 0)
            self.backgroundColorBlue = Double(cgColor.components?[2] ?? 0)
            self.backgroundColorAlpha = Double(cgColor.components?[3] ?? 0)
        } else {
            self.backgroundColorRed = 0.0
            self.backgroundColorGreen = 0.0
            self.backgroundColorBlue = 0.0
            self.backgroundColorAlpha = 0.0
        }
    }
}

// NOTE: This class is only used in v1.0.0
struct SavedDockTileInfo_V1_0_0: Codable {
    let uuid: UUID
    let backgroundColorRed: Double
    let backgroundColorGreen: Double
    let backgroundColorBlue: Double
    let backgroundColorAlpha: Double
    let savedImageFilePath: URL

    init(
        uuid: UUID,
        backgroundColor: NSColor,
        savedImageFilePath: URL
    ) {
        self.uuid = uuid
        self.savedImageFilePath = savedImageFilePath
        if let cgColor = backgroundColor.cgColor.converted(to: CGColorSpace(name: CGColorSpace.sRGB)!, intent: CGColorRenderingIntent.defaultIntent, options: nil) {
            self.backgroundColorRed = Double(cgColor.components?[0] ?? 0)
            self.backgroundColorGreen = Double(cgColor.components?[1] ?? 0)
            self.backgroundColorBlue = Double(cgColor.components?[2] ?? 0)
            self.backgroundColorAlpha = Double(cgColor.components?[3] ?? 0)
        } else {
            self.backgroundColorRed = 0.0
            self.backgroundColorGreen = 0.0
            self.backgroundColorBlue = 0.0
            self.backgroundColorAlpha = 0.0
        }
    }
}
