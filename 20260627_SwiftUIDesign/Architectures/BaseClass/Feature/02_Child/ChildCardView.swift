//
//  ChildCardView.swift
//  20260627_SwiftUIDesign
//

import SwiftUI
import Combine
import TaskCardsDomain

struct ChildCardView: View {
    @ObservedObject var cardVM: ChildCardViewModelBase
    let onTapItemDoneButton: (ItemViewModelBase.ID) -> Void
    let onTapItemFlagButton: (ItemViewModelBase.ID) -> Void
    let onTapCardExpandButton: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(cardVM.parsedCard.title)
                .font(.headline)

            Divider()

            ForEach(cardVM.visibleItems) { itemVM in
                ItemView(
                    itemVM: itemVM,
                    onTapDoneButton: { onTapItemDoneButton(itemVM.id) },
                    onTapFlagButton: { onTapItemFlagButton(itemVM.id) }
                )
            }

            if let isExpanded = cardVM.isExpanded {
                ExpandToggleButton(isExpanded: isExpanded) {
                    onTapCardExpandButton()
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
