import Foundation
import TaskCardsDomain

enum TaskCardsParser {

    static func parse(_ cards: [GetTaskCardsResponseModel.Card]) -> [ParsedCard] {
        cards.map { parse($0) }
    }

    // MARK: - Private

    private static func parse(_ card: GetTaskCardsResponseModel.Card) -> ParsedCard {
        let parsedItems = (card.items ?? []).map { parse($0) }
        let collapsedItemLimit = 2

        return ParsedCard(
            title: card.title ?? "",
            items: parsedItems,
            isExpandable: parsedItems.count > collapsedItemLimit,
            collapsedItemLimit: collapsedItemLimit
        )
    }

    private static func parse(_ item: GetTaskCardsResponseModel.Card.TaskItem) -> ParsedCard.ParsedTaskItem {
        ParsedCard.ParsedTaskItem(
            title: item.title ?? "",
            isDone: item.isDone ?? false,
            isFlaged: item.isFlaged ?? false
        )
    }
}
