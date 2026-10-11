//
//  IOS15ChildViewModel.swift
//  IOS15
//

import Foundation
import Combine
import TaskCardsDomain

// The protocol inherits Identifiable, so once the class is @MainActor the conformance must be @MainActor too.
// Otherwise, with MainActor default isolation or approachable concurrency enabled, the compiler warns
// "conformance crosses into main actor-isolated code".
@MainActor
final class IOS15ChildViewModel: @MainActor IOS15ChildViewModelProtocol {
    let id = UUID()
    let title: String
    let items: [IOS15ItemViewModel]
    @Published var isExpanded: Bool?

    private let collapsedItemLimit: Int

    var visibleItems: [IOS15ItemViewModel] {
        isExpanded == false ? Array(items.prefix(collapsedItemLimit)) : items
    }

    init(card: ParsedCard) {
        self.title = card.title
        self.items = card.items.map { item in IOS15ItemViewModel(item: item) }
        self.isExpanded = card.isExpandable ? false : nil
        self.collapsedItemLimit = card.collapsedItemLimit
    }
}
