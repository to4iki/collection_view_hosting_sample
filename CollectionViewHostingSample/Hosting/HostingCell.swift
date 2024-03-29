import SwiftUI
import UIKit

class HostingCell<Content: View>: UICollectionViewListCell {
  let hostingController = UIHostingController<Content?>(rootView: nil)

  override init(frame: CGRect) {
    super.init(frame: frame)
    hostingController.view.backgroundColor = .clear
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    hostingController.view.removeFromSuperview()
    hostingController.removeFromParent()
  }

  func configure(rootView: Content, parentViewController parent: UIViewController) {
    hostingController.rootView = rootView
    hostingController.view.invalidateIntrinsicContentSize()
    if hostingController.parent == nil {
      parent.addHostingController(hostingController, container: contentView)
    } else {
      // do nothing
    }
  }
}
