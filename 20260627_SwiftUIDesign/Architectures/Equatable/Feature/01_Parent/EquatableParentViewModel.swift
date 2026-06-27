//
//  EquatableParentViewModel.swift
//  Equatable
//

import Foundation
import Combine
import TaskCardsDomain

@MainActor
final class EquatableParentViewModel: ObservableObject {
    private let dataSource: TaskCardsDataSourceProtocol
    @Published private(set) var uiState = UiState()

    init(dataSource: TaskCardsDataSourceProtocol) {
        self.dataSource = dataSource
    }

    func load(userId: String) async {
        uiState.isLoading = true
        defer { uiState.isLoading = false }

        do {
            let parsed = try await dataSource.getTaskCards(userId: userId)
            uiState.cards = parsed.map { parsedCard in EquatableCardState(card: parsedCard) }
        } catch {
            // do nothing
        }
    }
}

// MARK: - User Actions

extension EquatableParentViewModel {
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

extension EquatableParentViewModel {
    struct UiState {
        var cards: [EquatableCardState] = []
        var isLoading = false
    }
}
