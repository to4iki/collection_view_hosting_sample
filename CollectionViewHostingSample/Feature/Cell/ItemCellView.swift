import SwiftUI

struct ItemUiState: Hashable {
  var id: Int
  var text: String
  var isPreview: Bool
}

struct ItemCellView: View {
  private var uiState: ItemUiState
  @State private var videoSize = CGSize.zero

  init(uiState: ItemUiState) {
    self.uiState = uiState
  }

  var body: some View {
    HStack(spacing: 8) {
      PreviewVideoPlayer(
        id: uiState.id,
//        url: "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8",
        url: "https://codeforfun.jp/demo/html/references/files/sample.mp4",
        isPreview: .init(
          get: { uiState.isPreview },
          set: { _ in }
        ),
        videoSize: $videoSize
      )
      .frame(width: 128, height: 72)
      .border(.gray)

      VStack(alignment: .leading, spacing: 4) {
        Text("text")
          .font(.caption)
          .foregroundColor(.gray)

        Text(uiState.text)
          .foregroundColor(.black)

        Text(videoSize.debugDescription)
          .foregroundColor(.black)
      }

      Spacer()
    }
  }
}
