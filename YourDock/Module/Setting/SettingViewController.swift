import Cocoa
import LaunchAtLogin

class SettingViewController: NSViewController {
    @objc dynamic var launchAtLogin = LaunchAtLogin.kvo

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
