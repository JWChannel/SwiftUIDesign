//
//  EquatableChildCardView.swift
//  Equatable
//

import SwiftUI
import TaskCardsDomain

struct EquatableChildCardView: View, Equatable {
    let card: EquatableCardState
    let onToggleItem: (ParsedCard.ParsedTaskItem.ID) -> Void
    let onToggleItemFlag: (ParsedCard.ParsedTaskItem.ID) -> Void
    let onToggleExpanded: () -> Void

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.card == rhs.card
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(card.title)
                .font(.headline)

            Divider()

            ForEach(card.visibleItems) { item in
                EquatableItemView(
                    item: item,
                    onToggle: { onToggleItem(item.id) },
                    onToggleFlag: { onToggleItemFlag(item.id) }
                )
                .equatable()
            }

            if let isExpanded = card.isExpanded {
                EquatableExpandToggleButton(isExpanded: isExpanded) {
                    onToggleExpanded()
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

#Preview {
    ChildCardPreviewContainer()
}

private struct ChildCardPreviewContainer: View {
    @State private var card = EquatableCardState(card: ParsedCard(
        title: "範例卡片",
        items: [
            ParsedCard.ParsedTaskItem(title: "項目一", isDone: true, isFlaged: false),
            ParsedCard.ParsedTaskItem(title: "項目二", isDone: false, isFlaged: false),
            ParsedCard.ParsedTaskItem(title: "項目三", isDone: false, isFlaged: false),
            ParsedCard.ParsedTaskItem(title: "項目四", isDone: false, isFlaged: false)
        ],
        isExpandable: true,
        collapsedItemLimit: 2
    ))

    var body: some View {
        EquatableChildCardView(
            card: card,
            onToggleItem: { itemID in
                guard let i = card.items.firstIndex(where: { $0.id == itemID }) else { return }
                card.items[i].isDone.toggle()
            },
            onToggleItemFlag: { itemID in
                guard let i = card.items.firstIndex(where: { $0.id == itemID }) else { return }
                card.items[i].isFlaged.toggle()
            },
            onToggleExpanded: {
                card.isExpanded?.toggle()
            }
        )
        .padding()
    }
}
