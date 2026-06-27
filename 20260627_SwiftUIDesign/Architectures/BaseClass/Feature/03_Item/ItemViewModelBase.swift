//
//  ItemViewModelBase.swift
//  20260627_SwiftUIDesign
//
//  Created by J W on 2026/6/30.
//

import SwiftUI
import Combine
import TaskCardsDomain

@MainActor
class ItemViewModelBase: ObservableObject, Identifiable {
    let id: UUID
    let parsedItem: ParsedCard.ParsedTaskItem
    @Published var isDone: Bool
    @Published var isFlaged: Bool
    
    init(item: ParsedCard.ParsedTaskItem) {
        id = item.id
        parsedItem = item
        isDone = item.isDone
        isFlaged = item.isFlaged
    }
}
