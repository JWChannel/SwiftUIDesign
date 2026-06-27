//
//  ItemView.swift
//  20260627_SwiftUIDesign
//

import SwiftUI
import Combine
import TaskCardsDomain

struct ItemView: View {
    @ObservedObject var itemVM: ItemViewModelBase
    let onTapDoneButton: () -> Void
    let onTapFlagButton: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onTapDoneButton) {
                HStack {
                    Image(systemName: itemVM.isDone ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(itemVM.isDone ? .green : .secondary)
                    
                    Text(itemVM.parsedItem.title)
                        .strikethrough(itemVM.isDone, color: .secondary)
                        .foregroundColor(itemVM.isDone ? .secondary : .primary)
                    
                    Spacer()
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Button(action: onTapFlagButton) {
                Image(systemName: itemVM.isFlaged ? "flag.fill" : "flag")
                    .foregroundColor(itemVM.isFlaged ? .orange : .secondary)
            }
            .buttonStyle(.plain)
        }
        .contentShape(Rectangle())
    }
}
