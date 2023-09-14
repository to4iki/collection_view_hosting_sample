import SwiftUI
import UIKit

final class ViewController: UIViewController {
  private typealias Section = SectionModel.Section
  private typealias CellItem = SectionModel.CellItem
  private typealias Cell = HostingCell<ItemCellView>

  private static let cellIdentifier = String(describing: Cell.self)

  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    collectionView.delegate = self
    collectionView.register(Cell.self, forCellWithReuseIdentifier: Self.cellIdentifier)
    return collectionView
  }()

  private let collectionViewLayout: UICollectionViewLayout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
    var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
    configuration.backgroundColor = .systemBackground
    configuration.showsSeparators = true
    let sectionLayout = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
    sectionLayout.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
    sectionLayout.interGroupSpacing = 8
    return sectionLayout
  }

  private lazy var collectionViewDataSource: UICollectionViewDiffableDataSource<Section, CellItem> = {
    UICollectionViewDiffableDataSource<Section, CellItem>(
      collectionView: collectionView
    ) { [weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
      return self?.provideCell(collectionView, indexPath: indexPath, item: item)
    }
  }()

  private lazy var sectionModel = SectionModel(
    section: .main,
    items: (1...10).map { index in
      CellItem(uiState: .init(
        id: index,
        text: String(repeating: index.description + "\n", count: index),
        isPreview: false
      ))
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
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.cellIdentifier, for: indexPath) as! Cell
    cell.configure(rootView: ItemCellView(uiState: item.uiState), parentViewController: self)
    return cell
  }
}

extension ViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: false)

    let newItems = sectionModel.items.enumerated().map { (index, item) in
      if index == indexPath.item {
        return CellItem(uiState: .init(id: item.uiState.id, text: item.uiState.text, isPreview: true))
      } else {
        return CellItem(uiState: .init(id: item.uiState.id, text: item.uiState.text, isPreview: false))
      }
    }
    self.sectionModel.items = newItems
    
    apply()
  }
}
