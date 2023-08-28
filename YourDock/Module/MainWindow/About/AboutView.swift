import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Image("AppIconForAsset")
                    .resizable()
                    .frame(width: 64, height: 64)
                Text(applicationName())
            }
            Text(AppText.copyRight)
        }
        .foregroundStyle(AppColor.contentMain)
    }
}
