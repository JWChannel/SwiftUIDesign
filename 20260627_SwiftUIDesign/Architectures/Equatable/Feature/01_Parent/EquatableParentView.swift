//
//  EquatableParentView.swift
//  Equatable
//

import SwiftUI
import TaskCardsDomain
import TaskCardsData

struct EquatableParentView: View {
    @StateObject private var parentVM = EquatableParentViewModel(dataSource: TaskCardsDataSource())

    var body: some View {
        ZStack {
            if parentVM.uiState.isLoading {
                ProgressView("Loading…")
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(parentVM.uiState.cards) { card in
                            EquatableChildCardView(
                                card: card,
                                onToggleItem: { itemId in
                                    parentVM.toggleItem(cardID: card.id,
                                                        itemID: itemId)
                                },
                                onToggleItemFlag: { itemId in
                                    parentVM.toggleItemFlag(cardID: card.id,
                                                            itemID: itemId)
                                },
                                onToggleExpanded: {
                                    parentVM.toggleExpanded(cardID: card.id)
                                }
                            )
                            .equatable()
                        }
                    }
                    .padding()
                }
            }
        }
        .task {
            await parentVM.load(userId: "demo-user")
        }
    }
}

#Preview {
    EquatableParentView()
}
