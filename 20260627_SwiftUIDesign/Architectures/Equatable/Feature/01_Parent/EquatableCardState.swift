//
//  EquatableCardState.swift
//  Equatable
//

import TaskCardsDomain

struct EquatableCardState: Identifiable, Equatable {
    let id: ParsedCard.ID
    let title: String
    let isExpandable: Bool
    let collapsedItemLimit: Int
    var items: [EquatableItemState]
    var isExpanded: Bool?

    init(card: ParsedCard) {
        self.id = card.id
        self.title = card.title
        self.isExpandable = card.isExpandable
        self.collapsedItemLimit = card.collapsedItemLimit
        self.items = card.items.map { taskItem in EquatableItemState(item: taskItem) }
        self.isExpanded = card.isExpandable ? false : nil
    }

    var visibleItems: [EquatableItemState] {
        isExpanded == false ? Array(items.prefix(collapsedItemLimit)) : items
    }
}

struct EquatableItemState: Identifiable, Equatable {
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
