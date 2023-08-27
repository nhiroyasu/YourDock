import AppKit

protocol GifDataRepository {
    func write(name: String, gifData: Data) throws -> URL
    func read(name: String) throws -> Data
    func remove(name: String) throws
    func removeAll() throws
}

class GifDataRepositoryImpl: GifDataRepository {
    private let fileManager: FileManager = .default

    func write(name: String, gifData: Data) throws -> URL {
        guard let bundleId = Bundle.main.bundleIdentifier else { throw NotDefinedBundleIdError() }
        var url = try fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        url.append(path: bundleId, directoryHint: .isDirectory)
        if !fileManager.fileExists(atPath: url.absoluteString) {
            try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
        }
        url.append(path: "\(name).gif", directoryHint: .notDirectory)
        info("attempt to write gif file to \(url.absoluteString)")

        try gifData.write(to: url)
        return url
    }

    func read(name: String) throws -> Data {
        guard let bundleId = Bundle.main.bundleIdentifier else { throw NotDefinedBundleIdError() }
        var url = try fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        url.append(path: bundleId, directoryHint: .isDirectory)
        url.append(path: "\(name).gif", directoryHint: .notDirectory)

        let data = try Data(contentsOf: url)
        return data
    }

    func remove(name: String) throws {
        guard let bundleId = Bundle.main.bundleIdentifier else { throw NotDefinedBundleIdError() }
        var url = try fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        url.append(path: bundleId, directoryHint: .isDirectory)
        url.append(path: "\(name).gif", directoryHint: .notDirectory)

        try fileManager.removeItem(at: url)
    }

    func removeAll() throws {
        guard let bundleId = Bundle.main.bundleIdentifier else { throw NotDefinedBundleIdError() }
        var url = try fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        url.append(path: bundleId, directoryHint: .isDirectory)
        let contents = try fileManager.contentsOfDirectory(atPath: url.absoluteString)
        try contents.forEach(fileManager.removeItem(atPath:))
    }
}
