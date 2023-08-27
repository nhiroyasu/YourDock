import AppKit

class GifLoopConverter {
    func convertLoopGif(gifData: Data) throws -> Data {
        let loopConfigurationPrefix: [UInt8] = [0x21, 0xFF, 0x0B, 0x4E, 0x45, 0x54, 0x53, 0x43, 0x41, 0x50, 0x45, 0x32, 0x2E, 0x30, 0x03]

        if let loopConfigurationPrefixRange = gifData.range(of: Data(loopConfigurationPrefix)) {
            var modifiedData = gifData
            modifiedData[loopConfigurationPrefixRange.upperBound + 1] = 0x00
            modifiedData[loopConfigurationPrefixRange.upperBound + 2] = 0x00
            return modifiedData
        } else {
            throw GifFormatError()
        }
    }
}
