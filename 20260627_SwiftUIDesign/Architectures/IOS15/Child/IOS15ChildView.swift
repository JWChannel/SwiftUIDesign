//
//  IOS15ChildView.swift
//  IOS15
//

import SwiftUI

struct IOS15ChildView<VM: IOS15ChildViewModelProtocol>: View {
    @ObservedObject var viewModel: VM
    let onAction: (ChildAction) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(viewModel.title)
                .font(.headline)

            Divider()

            ForEach(viewModel.visibleItems) { item in
                IOS15ItemView(
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
                .shadow(radius: 8)
        )
    }
}

#if Previews
#Preview {
    IOS15ChildPreviewContainer()
}

private struct IOS15ChildPreviewContainer: View {
    @StateObject private var viewModel = IOS15PreviewData.parentViewModel(.success(PreviewSampleData.cards))

    var body: some View {
        ZStack {
            if case let .loaded(cards) = viewModel.state, let card = cards.first {
                IOS15ChildView(viewModel: card) { action in
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
