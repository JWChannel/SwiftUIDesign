//
//  IOS15ChildViewModelProtocol.swift
//  IOS15
//

import Foundation
import Combine

@MainActor
protocol IOS15ChildViewModelProtocol: ObservableObject, Identifiable {
    var id: UUID { get }
    var title: String { get }
    var visibleItems: [IOS15ItemViewModel] { get }
    /// nil means the card is not expandable, so no expand button is shown
    var isExpanded: Bool? { get }
}
