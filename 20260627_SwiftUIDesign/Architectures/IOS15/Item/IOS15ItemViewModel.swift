//
//  IOS15ItemViewModel.swift
//  IOS15
//

import Foundation
import Combine
import TaskCardsDomain

// The protocol inherits Identifiable, so once the class is @MainActor the conformance must be @MainActor too.
// Otherwise, with MainActor default isolation or approachable concurrency enabled, the compiler warns
// "conformance crosses into main actor-isolated code".
@MainActor
final class IOS15ItemViewModel: @MainActor IOS15ItemViewModelProtocol {
    let id = UUID()
    let title: String
    @Published var isDone: Bool
    @Published var isFlaged: Bool

    init(item: ParsedCard.ParsedTaskItem) {
        self.title = item.title
        self.isDone = item.isDone
        self.isFlaged = item.isFlaged
    }
}
