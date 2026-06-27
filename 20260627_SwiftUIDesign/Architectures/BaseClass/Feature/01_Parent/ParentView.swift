//
//  ParentView.swift
//  20260627_SwiftUIDesign
//

import SwiftUI
import Combine
import TaskCardsDomain
import TaskCardsData

struct ParentView: View {
    @StateObject var parentVM: ParentViewModelBase = ParentViewModel(dataSource: TaskCardsDataSource())

    var body: some View {
        ZStack {
            if parentVM.isLoading {
                ProgressView("Loading…")
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(parentVM.cardVMs) { cardVM in
                            ChildCardView(
                                cardVM: cardVM,
                                onTapItemDoneButton: { itemID in
                                    parentVM.toggleItemDone(cardID: cardVM.id,
                                                            itemID: itemID)
                                },
                                onTapItemFlagButton: { itemID in
                                    parentVM.toggleItemFlag(cardID: cardVM.id,
                                                            itemID: itemID)
                                },
                                onTapCardExpandButton: {
                                    parentVM.toggleCardExpand(cardID: cardVM.id)
                                }
                            )
                        }
                    }
                    .padding()
                }
            }
        }
        .task {
            await parentVM.fetchData(userId: "demo-user")
        }
    }
}

#Preview {
    ParentView()
}
