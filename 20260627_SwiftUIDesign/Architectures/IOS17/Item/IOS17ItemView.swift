//
//  IOS17ItemView.swift
//  IOS17
//

import SwiftUI

struct IOS17ItemView<VM: IOS17ItemViewModelProtocol>: View, Equatable {
    let viewModel: VM
    let onToggleDone: () -> Void
    let onToggleFlag: () -> Void

    // Closures can't be compared, so SwiftUI would treat every row as changed whenever the card re-renders.
    // A row only depends on which view model it shows; that view model's own changes arrive through observation.
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.viewModel === rhs.viewModel
    }

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggleDone) {
                HStack {
                    Image(systemName: viewModel.isDone ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(viewModel.isDone ? .green : .secondary)

                    Text(viewModel.title)
                        .strikethrough(viewModel.isDone, color: .secondary)
                        .foregroundColor(viewModel.isDone ? .secondary : .primary)

                    Spacer()
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Button(action: onToggleFlag) {
                Image(systemName: viewModel.isFlaged ? "flag.fill" : "flag")
                    .foregroundColor(viewModel.isFlaged ? .orange : .secondary)
            }
            .buttonStyle(.plain)
        }
        .contentShape(Rectangle())
    }
}

#if Previews
#Preview {
    IOS17ItemPreviewContainer()
}

private struct IOS17ItemPreviewContainer: View {
    @State private var viewModel = IOS17PreviewData.parentViewModel(.success(PreviewSampleData.cards))

    var body: some View {
        ZStack {
            if case let .loaded(cards) = viewModel.state, let card = cards.first, let item = card.visibleItems.first {
                IOS17ItemView(
                    viewModel: item,
                    onToggleDone: { viewModel.handle(.toggleItemDone(id: card.id, itemID: item.id)) },
                    onToggleFlag: { viewModel.handle(.toggleItemFlag(id: card.id, itemID: item.id)) }
                )
                .padding()
            }
        }
        .task {
            await viewModel.load()
        }
    }
}
#endif
