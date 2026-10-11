//
//  IOS17ChildView.swift
//  IOS17
//

import SwiftUI

struct IOS17ChildView<VM: IOS17ChildViewModelProtocol>: View {
    let viewModel: VM
    let onAction: (ChildAction) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(viewModel.title)
                .font(.headline)

            Divider()

            ForEach(viewModel.visibleItems) { item in
                IOS17ItemView(
                    viewModel: item,
                    onToggleDone: { onAction(.toggleItemDone(id: viewModel.id, itemID: item.id)) },
                    onToggleFlag: { onAction(.toggleItemFlag(id: viewModel.id, itemID: item.id)) }
                )
                .equatable()
            }

            if let isExpanded = viewModel.isExpanded {
                ExpandToggleButton(isExpanded: isExpanded) {
                    onAction(.toggleExpanded(id: viewModel.id))
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
                .shadow(radius: 6)
        )
    }
}

#if Previews
#Preview {
    IOS17ChildPreviewContainer()
}

private struct IOS17ChildPreviewContainer: View {
    @State private var viewModel = IOS17PreviewData.parentViewModel(.success(PreviewSampleData.cards))

    var body: some View {
        ZStack {
            if case let .loaded(cards) = viewModel.state, let card = cards.first {
                IOS17ChildView(viewModel: card) { action in
                    viewModel.handle(action)
                }
                .padding()
            }
        }
        .task {
            await viewModel.load()
        }
    }
}
#endif
