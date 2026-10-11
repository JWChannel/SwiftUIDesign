//
//  IOS17ItemViewModelProtocol.swift
//  IOS17
//

import Foundation
import Observation

@MainActor
protocol IOS17ItemViewModelProtocol: AnyObject, Observable, Identifiable {
    var id: UUID { get }
    var title: String { get }
    var isDone: Bool { get }
    var isFlaged: Bool { get }
}
