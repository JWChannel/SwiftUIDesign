//
//  IOS17ParentView.swift
//  IOS17
//

import SwiftUI

struct IOS17ParentView<VM: IOS17ParentViewModelProtocol>: View {
    let viewModel: VM

    var body: some View {
        ZStack {
            switch viewModel.state {
            case .loading:
                ProgressView("Loading…")
            case .loaded(let cards):
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(cards) { card in
                            IOS17ChildView(viewModel: card) { action in
                                viewModel.handle(action)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .task {
            await viewModel.load()
        }
    }
}

#if Previews
#Preview("Loaded") {
    IOS17ParentView(viewModel: IOS17PreviewData.parentViewModel(.success(PreviewSampleData.cards)))
}

#Preview("Load failed") {
    IOS17ParentView(viewModel: IOS17PreviewData.parentViewModel(.failure(URLError(.badServerResponse))))
}
#endif
