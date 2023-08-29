import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Image("AppIconForAsset")
                    .resizable()
                    .frame(width: 64, height: 64)
                Text(applicationName())
                Button {
                    NSWorkspace.shared.open(Constants.githubUrl)
                } label: {
                    Image(nsImage: Constants.githubIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                }
                .buttonStyle(.plain)
                .onHover { inside in
                    if inside {
                        NSCursor.pointingHand.push()
                    } else {
                        NSCursor.pop()
                    }
                }
                .padding(8)
            }
            Text(AppText.copyRight)
        }
        .foregroundStyle(AppColor.contentMain)
    }
}
