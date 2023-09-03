import AppKit
import SwiftUI
import Combine

struct DockTileItem: Identifiable {
    // NOTE: id is equal to dock module id
    let id: UUID
    let name: String
    let config: DockIconConfig
}

struct DockListView: View {
    let controller: DockListController
    let dockListPublisher: AnyPublisher<[DockTileItem], Never>
    @State private var dockList: [DockTileItem] = []

    func nsImage(gifData: Data?) -> NSImage {
        guard let data = gifData,
              let image = NSImage(data: data) else { return NSImage(size: .zero) }
        return image
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: true, content: {
            LazyVStack(alignment: .leading) {
                ForEach(dockList, id: \.id) { item in
                    Button {
                        controller.didTapDock(at: item.id)
                    } label: {
                        HStack {
                            DockIconView(config: item.config)
                            Text(item.name)
                                .foregroundStyle(AppColor.contentMain)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Button {
                                controller.didTapRemoveButton(at: item.id)
                            } label: {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .frame(width: 12, height: 12)
                                    .padding(8)
                                    .foregroundStyle(AppColor.controlColor)
                                    .onHover { inside in
                                        if inside {
                                            NSCursor.pointingHand.push()
                                        } else {
                                            NSCursor.pop()
                                        }
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background(Rectangle().fill(AppColor.backgroundColor))
                        .overlay(alignment: .bottom) {
                            Rectangle()
                                .fill(.separator)
                                .frame(height: 1)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .buttonStyle(.plain)
                    .onHover { inside in
                        if inside {
                            NSCursor.pointingHand.push()
                        } else {
                            NSCursor.pop()
                        }
                    }
                }
            }
        })
        .onReceive(dockListPublisher) { newDockList in
            self.dockList = newDockList
        }
        .overlay(alignment: .bottomTrailing) {
            Button {
                controller.didTapAddButton()
            } label: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColor.primary)
                    .frame(width: 48, height: 48)
                    .shadow(radius: 2, y: 2)
                    .overlay {
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .padding(16)
                            .foregroundStyle(.white)
                    }
            }
            .padding(16)
            .buttonStyle(.plain)
            .onHover { inside in
                if inside {
                    NSCursor.pointingHand.push()
                } else {
                    NSCursor.pop()
                }
            }
        }
        .background(AppColor.backgroundColor)
    }
}
