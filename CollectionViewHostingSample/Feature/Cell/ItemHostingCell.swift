import UIKit

final class ItemHostingCell: HostingCell<ItemCellView> {
  static let identifier = String(describing: ItemHostingCell.self)

  override init(frame: CGRect) {
    super.init(frame: frame)
  }
}
