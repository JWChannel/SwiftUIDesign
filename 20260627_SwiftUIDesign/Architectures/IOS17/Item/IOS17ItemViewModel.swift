//
//  IOS17ItemViewModel.swift
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
final class IOS17ItemViewModel: @MainActor IOS17ItemViewModelProtocol {
    let id = UUID()
    let title: String
    var isDone: Bool
    var isFlaged: Bool

    init(item: ParsedCard.ParsedTaskItem) {
        self.title = item.title
        self.isDone = item.isDone
        self.isFlaged = item.isFlaged
    }
}
