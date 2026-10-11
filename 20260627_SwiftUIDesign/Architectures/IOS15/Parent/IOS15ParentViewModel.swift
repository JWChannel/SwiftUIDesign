//
//  IOS15ParentViewModel.swift
//  IOS15
//

import Foundation
import Combine
import TaskCardsDomain

@MainActor
final class IOS15ParentViewModel: IOS15ParentViewModelProtocol {
    @Published private(set) var state: IOS15ParentUIState = .loading

    private let userId: String
    private let dataSource: TaskCardsDataSourceProtocol

    init(userId: String, dataSource: TaskCardsDataSourceProtocol) {
        self.userId = userId
        self.dataSource = dataSource
    }

    func load() async {
        state = .loading
        do {
            let cards = try await dataSource.getTaskCards(userId: userId)
            state = .loaded(cards.map { card in IOS15ChildViewModel(card: card) })
        } catch {
            // Same as before the refactor: a failed load shows an empty list
            state = .loaded([])
        }
    }

    func handle(_ action: ChildAction) {
        switch action {
        case .toggleItemDone(let id, let itemID):
            toggleItemDone(id: id, itemID: itemID)
        case .toggleItemFlag(let id, let itemID):
            toggleItemFlag(id: id, itemID: itemID)
        case .toggleExpanded(let id):
            toggleExpanded(id: id)
        }
    }

    private func toggleItemDone(id: UUID, itemID: UUID) {
        itemViewModel(for: itemID, in: id)?.isDone.toggle()
    }

    private func toggleItemFlag(id: UUID, itemID: UUID) {
        itemViewModel(for: itemID, in: id)?.isFlaged.toggle()
    }

    private func toggleExpanded(id: UUID) {
        childViewModel(for: id)?.isExpanded?.toggle()
    }

    private func childViewModel(for id: UUID) -> IOS15ChildViewModel? {
        guard case let .loaded(cards) = state else { return nil }
        return cards.first { $0.id == id }
    }

    private func itemViewModel(for itemID: UUID, in cardID: UUID) -> IOS15ItemViewModel? {
        childViewModel(for: cardID)?.items.first { $0.id == itemID }
    }
}
