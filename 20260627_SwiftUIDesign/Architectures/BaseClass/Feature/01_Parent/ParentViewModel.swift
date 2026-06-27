//
//  ParentViewModel.swift
//  20260627_SwiftUIDesign
//

import Foundation
import Combine
import TaskCardsDomain

final class ParentViewModel: ParentViewModelBase {
    override func fetchData(userId: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            let parsed = try await dataSource.getTaskCards(userId: userId)
            cardVMs = parsed.map { parsedCard in
                ChildCardViewModel(card: parsedCard)
            }
        } catch {
            // do nothing
        }
    }
    
    override func toggleItemFlag(cardID: UUID, itemID: UUID) {
        guard let itemVM = cardVMs.first(where: { $0.id == cardID })?.itemVMs.first(where: { $0.id == itemID }) as? ItemViewModel
        else { return }
        itemVM.toggleFlag()
    }

    override func toggleItemDone(cardID: UUID, itemID: UUID) {
        guard let itemVM = cardVMs.first(where: { $0.id == cardID })?.itemVMs.first(where: { $0.id == itemID }) as? ItemViewModel
        else { return }
        itemVM.toggleDone()
    }

    override func toggleCardExpand(cardID: UUID) {
        cardVMs.first { $0.id == cardID }?.isExpanded?.toggle()
    }
}
