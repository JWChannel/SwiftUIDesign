//
//  ObservableParentView.swift
//  Observable
//

import SwiftUI
import TaskCardsData
import TaskCardsDomain

struct ObservableParentView: View {
    @State private var parentVM = ObservableParentViewModel(dataSource: TaskCardsDataSource())

    var body: some View {
        ZStack {
            if parentVM.uiState.isLoading {
                ProgressView("Loading…")
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(parentVM.uiState.cards) { card in
                            ObservableChildCardView(
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
    ObservableParentView()
}
