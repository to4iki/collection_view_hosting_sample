import SwiftUI
import UIKit

final class ViewController: UIViewController {
  private typealias Section = SectionModels.Section
  private typealias CellItem = SectionModels.CellItem

  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    if #unavailable(iOS 16.0) {
      collectionView.register(ItemHostingCell.self, forCellWithReuseIdentifier: ItemHostingCell.identifier)
    }
    return collectionView
  }()

  private let collectionViewLayout: UICollectionViewLayout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
    var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
    configuration.backgroundColor = .systemBackground
    let sectionLayout = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
    sectionLayout.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
    sectionLayout.interGroupSpacing = 8
    return sectionLayout
  }

  private lazy var collectionViewDataSource: UICollectionViewDiffableDataSource<Section, CellItem> = {
    let itemCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, CellItem> { (cell, indexPath, item) in
      if #available(iOS 16.0, *) {
        cell.contentConfiguration = UIHostingConfiguration {
          ItemCellView(text: item.text)
        }
      }
    }
    return UICollectionViewDiffableDataSource<Section, CellItem>(
      collectionView: collectionView
    ) { [weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
      if #available(iOS 16.0, *) {
        return collectionView.dequeueConfiguredReusableCell(using: itemCellRegistration, for: indexPath, item: item)
      } else {
        return self?.provideCell(collectionView, indexPath: indexPath, item: item)
      }
    }
  }()

  private let sectionModel = SectionModels(
    section: .main,
    items: (1...10).map { index in
      CellItem(text: String(repeating: index.description + "\n", count: index))
    }
  )

  override func loadView() {
    super.loadView()
    self.view = collectionView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always
    navigationItem.title = "List"

    apply()
  }
}

extension ViewController {
  private func apply() {
    var dataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, CellItem>()
    dataSourceSnapshot.appendSections([sectionModel.section])
    dataSourceSnapshot.appendItems(sectionModel.items)
    collectionViewDataSource.apply(dataSourceSnapshot, animatingDifferences: false)
  }

  private func provideCell(_ collectionView: UICollectionView, indexPath: IndexPath, item: CellItem) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemHostingCell.identifier, for: indexPath) as! ItemHostingCell
    cell.configure(rootView: ItemCellView(text: item.text), parentViewController: self)
    return cell
  }
}
