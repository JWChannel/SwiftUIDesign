//
//  ObservableCardUIState.swift
//  Observable
//

import TaskCardsDomain

struct ObservableCardUIState: Identifiable {
    let id: ParsedCard.ID
    let title: String
    let isExpandable: Bool
    let collapsedItemLimit: Int
    var items: [ObservableItemUIState]
    var isExpanded: Bool?

    init(card: ParsedCard) {
        self.id = card.id
        self.title = card.title
        self.isExpandable = card.isExpandable
        self.collapsedItemLimit = card.collapsedItemLimit
        self.items = card.items.map { taskItem in
            ObservableItemUIState(item: taskItem)
        }
        self.isExpanded = card.isExpandable ? false : nil
    }

    var visibleItems: [ObservableItemUIState] {
        isExpanded == false ? Array(items.prefix(collapsedItemLimit)) : items
    }
}

struct ObservableItemUIState: Identifiable {
    let id: ParsedCard.ParsedTaskItem.ID
    let title: String
    var isDone: Bool
    var isFlaged: Bool

    init(item: ParsedCard.ParsedTaskItem) {
        self.id = item.id
        self.title = item.title
        self.isDone = item.isDone
        self.isFlaged = item.isFlaged
    }
}
