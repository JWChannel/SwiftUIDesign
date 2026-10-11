//
//  IOS15ItemViewModelProtocol.swift
//  IOS15
//

import Foundation
import Combine

@MainActor
protocol IOS15ItemViewModelProtocol: ObservableObject, Identifiable {
    var id: UUID { get }
    var title: String { get }
    var isDone: Bool { get }
    var isFlaged: Bool { get }
}
