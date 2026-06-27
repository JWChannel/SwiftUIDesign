//
//  ChildCardViewModel.swift
//  20260627_SwiftUIDesign
//

import Foundation
import Combine

final class ChildCardViewModel: ChildCardViewModelBase {
    func toggleExpand() {
        isExpanded?.toggle()
    }
}
