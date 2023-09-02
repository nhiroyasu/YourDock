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
    let dockIconsSubject: CurrentValueSubject<[DockIcon], Never>
    private var dockListPublisher: AnyPublisher<[DockTileItem], Never> {
        dockIconsSubject
            .map { (dockIcons: [DockIcon]) -> [DockTileItem] in
                dockIcons.map { dockIcon in
                    DockTileItem(
                        id: dockIcon.id,
                        name: dockIcon.name,
                        config: dockIcon.config
                    )
                }
            }
            .eraseToAnyPublisher()
    }

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
                DockListView(
                    controller: dockListController,
                    dockListPublisher: dockListPublisher
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
