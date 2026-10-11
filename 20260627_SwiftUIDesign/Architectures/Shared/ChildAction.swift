//
//  ChildAction.swift
//  Shared
//

import Foundation

enum ChildAction {
    case toggleItemDone(id: UUID, itemID: UUID)
    case toggleItemFlag(id: UUID, itemID: UUID)
    case toggleExpanded(id: UUID)
}
