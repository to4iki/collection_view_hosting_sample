struct SectionModel{
  enum Section: Hashable {
    case main
  }

  struct CellItem: Hashable {
    var uiState: ItemUiState
  }

  var section: Section
  var items: [CellItem]
}
