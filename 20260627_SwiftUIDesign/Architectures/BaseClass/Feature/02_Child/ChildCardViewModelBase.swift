//
//  ChildCardViewModelBase.swift
//  20260627_SwiftUIDesign
//
//  Created by J W on 2026/6/30.
//
import SwiftUI
import Combine
import TaskCardsDomain

@MainActor
class ChildCardViewModelBase: ObservableObject, Identifiable {
    let id: UUID
    let parsedCard: ParsedCard
    let itemVMs: [ItemViewModelBase]
    @Published var isExpanded: Bool?
    var visibleItems: [ItemViewModelBase] {
        isExpanded == false
            ? Array(itemVMs.prefix(parsedCard.collapsedItemLimit))
            : itemVMs
    }

    init(card: ParsedCard) {
        id = card.id
        parsedCard = card
        itemVMs = card.items.map { parsedItem in
            ItemViewModel(item: parsedItem)
        }
        isExpanded = card.isExpandable ? false : nil   // ← base 裡設好,免得忘
    }
}
