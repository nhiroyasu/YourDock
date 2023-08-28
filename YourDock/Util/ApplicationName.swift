import Foundation

func applicationName() -> String {
    (Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String) ?? ""
}
