import SwiftUI
import LaunchAtLogin

struct SettingView: View {
    @ObservedObject private var launchAtLogin = LaunchAtLogin.observable
    @AppStorage(wrappedValue: true, UserDefaults.Keys.showingAppDock.rawValue, store: .standard)
    var showingAppDock: Bool
    @AppStorage(wrappedValue: true, UserDefaults.Keys.showingIconOnMenubar.rawValue, store: .standard)
    var showingIconOnMenubar: Bool

    var body: some View {
        List {
            Section("System") {
                Group {
                    Toggle("Launch at login", isOn: $launchAtLogin.isEnabled)
                    Toggle("Show app's dock icon", isOn: $showingAppDock)
                        .disabled(!showingIconOnMenubar)
                    Toggle("Show icon on the menubar", isOn: $showingIconOnMenubar)
                        .disabled(!showingAppDock)
                }
                .foregroundStyle(AppColor.contentMain)
            }
        }
        .listStyle(.bordered)
    }
}
