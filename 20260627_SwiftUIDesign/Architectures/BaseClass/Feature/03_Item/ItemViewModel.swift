//
//  ItemViewModel.swift
//  20260627_SwiftUIDesign
//
//  Created by J W on 2026/6/29.
//

import Foundation
import Combine

final class ItemViewModel: ItemViewModelBase {
    func toggleDone() {
        isDone.toggle()
    }
    func toggleFlag() {
        isFlaged.toggle()
    }
}
