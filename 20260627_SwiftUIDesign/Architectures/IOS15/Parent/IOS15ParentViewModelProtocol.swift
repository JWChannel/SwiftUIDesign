//
//  IOS15ParentViewModelProtocol.swift
//  IOS15
//

import Combine

@MainActor
protocol IOS15ParentViewModelProtocol: ObservableObject {
    var state: IOS15ParentUIState { get }
    func load() async
    func handle(_ action: ChildAction)
}
