//
//  IOS15PreviewData.swift
//  IOS15
//

#if Previews
import TaskCardsDomain

@MainActor
enum IOS15PreviewData {
    static func parentViewModel(_ result: Result<[ParsedCard], Error>) -> IOS15ParentViewModel {
        IOS15ParentViewModel(userId: "preview-user", dataSource: DemoDataSource(result: result))
    }

    /// The data source is async, so `state` only settles after `load()` returns
    static func loadedCards(_ result: Result<[ParsedCard], Error>) async -> [IOS15ChildViewModel] {
        let viewModel = parentViewModel(result)
        await viewModel.load()

        guard case let .loaded(cards) = viewModel.state else { return [] }
        return cards
    }
}
#endif
