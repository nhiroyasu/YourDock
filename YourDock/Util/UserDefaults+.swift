import AppKit

struct SavedDockTileInfo: Codable {
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

extension UserDefaults {
    var dockTileInfoArray: [SavedDockTileInfo] {
        get {
            let jsonDecoder = JSONDecoder()
            do {
                let str = self.string(forKey: "dockTileInfoArray")
                if let str, let data = str.data(using: .utf8) {
                    let returnValue = try jsonDecoder.decode([SavedDockTileInfo].self, from: data)
                    return returnValue
                } else {
                    return []
                }
            } catch {
                return []
            }
        }
        set {
            let jsonEncoder = JSONEncoder()
            do {
                let data = try jsonEncoder.encode(newValue)
                self.setValue(String(data: data, encoding: .utf8), forKey: "dockTileInfoArray")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
