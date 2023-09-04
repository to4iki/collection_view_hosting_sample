import SwiftUI
import UIKit

extension UIViewController {
  func addHostingController(_ hostingController: UIHostingController<some View>) {
    addHostingController(hostingController, container: self.view)
  }

  func addHostingController(_ hostingController: UIHostingController<some View>, container containerView: UIView) {
    hostingController.willMove(toParent: self)
    addChild(hostingController)
    containerView.addSubview(hostingController.view)
    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      hostingController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
      hostingController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
      hostingController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      hostingController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
    ])
    hostingController.didMove(toParent: self)
  }
}
