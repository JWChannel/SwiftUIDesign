//
//  EquatableItemView.swift
//  Equatable
//

import SwiftUI
import TaskCardsDomain

struct EquatableItemView: View, Equatable {
    let item: EquatableItemState
    let onToggle: () -> Void
    let onToggleFlag: () -> Void

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.item == rhs.item
    }

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                HStack {
                    Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(item.isDone ? .green : .secondary)

                    Text(item.title)
                        .strikethrough(item.isDone, color: .secondary)
                        .foregroundColor(item.isDone ? .secondary : .primary)

                    Spacer()
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Button(action: onToggleFlag) {
                Image(systemName: item.isFlaged ? "flag.fill" : "flag")
                    .foregroundColor(item.isFlaged ? .orange : .secondary)
            }
            .buttonStyle(.plain)
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    ItemPreviewContainer()
}

private struct ItemPreviewContainer: View {
    @State private var isDone = false
    @State private var isFlaged = false

    var body: some View {
        EquatableItemView(
            item: EquatableItemState(item: ParsedCard.ParsedTaskItem(title: "範例任務", isDone: isDone, isFlaged: isFlaged)),
            onToggle: { isDone.toggle() },
            onToggleFlag: { isFlaged.toggle() }
        )
        .padding()
    }
}
