//
//  ObservableParentViewModel.swift
//  Observable
//

import Foundation
import SwiftUI
import TaskCardsDomain

@Observable
@MainActor
final class ObservableParentViewModel {
    private let dataSource: TaskCardsDataSourceProtocol
    private(set) var uiState = UiState()

    init(dataSource: TaskCardsDataSourceProtocol) {
        self.dataSource = dataSource
    }

    func load(userId: String) async {
        uiState.isLoading = true
        defer { uiState.isLoading = false }

        do {
            let parsed = try await dataSource.getTaskCards(userId: userId)
            uiState.cards = parsed.map { parsedCard in ObservableCardUIState(card: parsedCard) }
        } catch {
            // do nothing
        }
    }
}

// MARK: - User Actions

extension ObservableParentViewModel {
    func toggleItem(cardID: ParsedCard.ID,
                    itemID: ParsedCard.ParsedTaskItem.ID) {
        guard let cardIndex = uiState.cards.firstIndex(where: { $0.id == cardID }),
              let itemIndex = uiState.cards[cardIndex].items.firstIndex(where: { $0.id == itemID })
        else { return }
        uiState.cards[cardIndex].items[itemIndex].isDone.toggle()
    }

    func toggleItemFlag(cardID: ParsedCard.ID,
                        itemID: ParsedCard.ParsedTaskItem.ID) {
        guard let cardIndex = uiState.cards.firstIndex(where: { $0.id == cardID }),
              let itemIndex = uiState.cards[cardIndex].items.firstIndex(where: { $0.id == itemID })
        else { return }
        uiState.cards[cardIndex].items[itemIndex].isFlaged.toggle()
    }

    func toggleExpanded(cardID: ParsedCard.ID) {
        guard let cardIndex = uiState.cards.firstIndex(where: { $0.id == cardID })
        else { return }
        uiState.cards[cardIndex].isExpanded?.toggle()
    }
}

// MARK: - UI State

extension ObservableParentViewModel {
    struct UiState {
        var cards: [ObservableCardUIState] = []
        var isLoading = false
    }
}
