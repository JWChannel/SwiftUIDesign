//
//  IOS17ChildViewModel.swift
//  IOS17
//

import Foundation
import Observation
import TaskCardsDomain

// The protocol inherits Identifiable, so once the class is @MainActor the conformance must be @MainActor too.
// Otherwise, with MainActor default isolation or approachable concurrency enabled, the compiler warns
// "conformance crosses into main actor-isolated code".
@Observable
@MainActor
final class IOS17ChildViewModel: @MainActor IOS17ChildViewModelProtocol {
    let id = UUID()
    let title: String
    let items: [IOS17ItemViewModel]
    var isExpanded: Bool?

    private let collapsedItemLimit: Int

    var visibleItems: [IOS17ItemViewModel] {
        isExpanded == false ? Array(items.prefix(collapsedItemLimit)) : items
    }

    init(card: ParsedCard) {
        self.title = card.title
        self.items = card.items.map { item in IOS17ItemViewModel(item: item) }
        self.isExpanded = card.isExpandable ? false : nil
        self.collapsedItemLimit = card.collapsedItemLimit
    }
}
