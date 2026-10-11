//
//  IOS17ParentViewModelProtocol.swift
//  IOS17
//

import Observation

@MainActor
protocol IOS17ParentViewModelProtocol: AnyObject, Observable {
    var state: IOS17ParentUIState { get }
    func load() async
    func handle(_ action: ChildAction)
}
