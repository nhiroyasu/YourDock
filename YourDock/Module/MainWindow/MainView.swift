import SwiftUI
import Combine

struct MainView: View {
    private let sideMenuItems: [SideMenuItem] = [
        SideMenuItem(id: .dockList, name: "Home", icon: "house"),
        SideMenuItem(id: .setting, name: "Setting", icon: "gearshape"),
        SideMenuItem(id: .about, name: "About", icon: "info.circle"),
    ]
    @State private var sideMenuSelectionItem: SplitContentItem? = .dockList
    @State private var splitContentPath: [SplitContentItem] = [.dockList]
    let dockListController: DockListController
    let moduleContainersSubject: CurrentValueSubject<[CustomizeDockIconModuleContainer], Never>

    var body: some View {
        NavigationSplitView {
            List(sideMenuItems, id: \.id, selection: $sideMenuSelectionItem) { sideMenu in
                Label(
                    title: { Text(sideMenu.name) },
                    icon: {
                        Image(systemName: sideMenu.icon)
                    }
                )
            }
            .listStyle(.sidebar)
        } detail: {
            switch sideMenuSelectionItem {
            case .dockList:
                let dockListPublisher = moduleContainersSubject.map { (containers: [CustomizeDockIconModuleContainer]) -> [DockTileItem] in
                    containers.map {
                        .init(
                            id: $0.uuid,
                            name: $0.preservedState.name,
                            gifData: $0.preservedState.gifData,
                            backgroundColor: $0.preservedState.backgroundColor
                        )
                    }
                }
                DockListView(
                    controller: dockListController,
                    dockListPublisher: dockListPublisher.eraseToAnyPublisher()
                )
            case .setting:
                SettingView()
            case .about:
                AboutView()
            case .none:
                EmptyView()
            }
        }
        .frame(width: 800, height: 500)
    }
}

extension MainView {
    struct SideMenuItem: Identifiable {
        let id: SplitContentItem
        let name: String
        let icon: String
    }

    enum SplitContentItem: String, Hashable {
        case dockList
        case setting
        case about
    }
}
