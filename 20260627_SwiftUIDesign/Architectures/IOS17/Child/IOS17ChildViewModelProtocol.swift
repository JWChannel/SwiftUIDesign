//
//  IOS17ChildViewModelProtocol.swift
//  IOS17
//

import Foundation
import Observation

@MainActor
protocol IOS17ChildViewModelProtocol: AnyObject, Observable, Identifiable {
    var id: UUID { get }
    var title: String { get }
    var visibleItems: [IOS17ItemViewModel] { get }
    /// nil means the card is not expandable, so no expand button is shown
    var isExpanded: Bool? { get }
}
