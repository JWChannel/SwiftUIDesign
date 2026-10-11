//
//  IOS17PreviewData.swift
//  IOS17
//

#if Previews
import TaskCardsDomain

@MainActor
enum IOS17PreviewData {
    static func parentViewModel(_ result: Result<[ParsedCard], Error>) -> IOS17ParentViewModel {
        IOS17ParentViewModel(userId: "preview-user", dataSource: DemoDataSource(result: result))
    }

    /// The data source is async, so `state` only settles after `load()` returns
    static func loadedCards(_ result: Result<[ParsedCard], Error>) async -> [IOS17ChildViewModel] {
        let viewModel = parentViewModel(result)
        await viewModel.load()

        guard case let .loaded(cards) = viewModel.state else { return [] }
        return cards
    }
}
#endif
