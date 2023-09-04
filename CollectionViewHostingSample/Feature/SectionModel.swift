struct SectionModels {
  enum Section: Hashable {
    case main
  }

  struct CellItem: Hashable {
    let text: String
  }

  let section: Section
  let items: [CellItem]
}
