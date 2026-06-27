//
//  ParentViewModelBase.swift
//  20260627_SwiftUIDesign
//
//  Created by J W on 2026/6/30.
//


import SwiftUI
import Combine
import TaskCardsDomain

@MainActor
class ParentViewModelBase: ObservableObject {
    let dataSource: TaskCardsDataSourceProtocol
    @Published var cardVMs: [ChildCardViewModelBase] = []
    @Published var isLoading = false

    init(dataSource: TaskCardsDataSourceProtocol) {
        self.dataSource = dataSource
    }

    func fetchData(userId: String) async {}
    func toggleItemDone(cardID: UUID, itemID: UUID) {}
    func toggleItemFlag(cardID: UUID, itemID: UUID) {}
    func toggleCardExpand(cardID: UUID) {}
}