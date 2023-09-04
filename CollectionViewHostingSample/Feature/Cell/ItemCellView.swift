import SwiftUI

struct ItemCellView: View {
  private let text: String

  init(text: String) {
    self.text = text
  }

  var body: some View {
    HStack {
      Text(text)
      Spacer()
    }
    .background(Color.gray)
  }
}
