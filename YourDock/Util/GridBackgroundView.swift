import Cocoa

class GridBackgroundView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Clear the background
        NSColor.clear.set()
        dirtyRect.fill()

        // Define the grid parameters
        let rowCount = 36
        let colCount = 36
        let squareSize = CGSize(width: dirtyRect.width / CGFloat(colCount), height: dirtyRect.height / CGFloat(rowCount))

        let colors: [NSColor] = [.white, NSColor(red: 0xD0/0xFF, green: 0xD0/0xFF, blue: 0xD0/0xFF, alpha: 1.0)]

        for row in 0..<rowCount {
            for col in 0..<colCount {
                let colorIndex = (row + col) % colors.count
                let color = colors[colorIndex]
                let squareRect = NSRect(x: CGFloat(col) * squareSize.width, y: CGFloat(row) * squareSize.height, width: squareSize.width, height: squareSize.height)
                color.setFill()
                squareRect.fill()
            }
        }
    }
}
