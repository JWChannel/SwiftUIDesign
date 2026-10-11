//
//  PreviewSampleData.swift
//  Shared
//

#if Previews
import TaskCardsDomain

enum PreviewSampleData {
    static let cards: [ParsedCard] = [
        ParsedCard(
            title: "Expandable card",
            items: [
                ParsedCard.ParsedTaskItem(title: "Item 1", isDone: true, isFlaged: false),
                ParsedCard.ParsedTaskItem(title: "Item 2", isDone: false, isFlaged: true),
                ParsedCard.ParsedTaskItem(title: "Item 3", isDone: false, isFlaged: false),
                ParsedCard.ParsedTaskItem(title: "Item 4", isDone: false, isFlaged: false)
            ],
            isExpandable: true,
            collapsedItemLimit: 2
        ),
        ParsedCard(
            title: "Non-expandable card",
            items: [
                ParsedCard.ParsedTaskItem(title: "Item 1", isDone: false, isFlaged: false),
                ParsedCard.ParsedTaskItem(title: "Item 2", isDone: true, isFlaged: false)
            ],
            isExpandable: false,
            collapsedItemLimit: 2
        )
    ]
}

struct DemoDataSource: TaskCardsDataSourceProtocol {
    let result: Result<[ParsedCard], Error>

    func getTaskCards(userId: String) async throws -> [ParsedCard] {
        try result.get()
    }
}
#endif
