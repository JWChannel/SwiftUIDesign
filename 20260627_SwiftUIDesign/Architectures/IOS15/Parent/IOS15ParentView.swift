//
//  IOS15ParentView.swift
//  IOS15
//

import SwiftUI

struct IOS15ParentView<VM: IOS15ParentViewModelProtocol>: View {
    @ObservedObject var viewModel: VM

    var body: some View {
        ZStack {
            switch viewModel.state {
            case .loading:
                ProgressView("Loading…")
            case .loaded(let cards):
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(cards) { card in
                            IOS15ChildView(viewModel: card) { action in
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
    IOS15ParentView(viewModel: IOS15PreviewData.parentViewModel(.success(PreviewSampleData.cards)))
}

#Preview("Load failed") {
    IOS15ParentView(viewModel: IOS15PreviewData.parentViewModel(.failure(URLError(.badServerResponse))))
}
#endif
