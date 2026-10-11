//
//  IOS17HomeView.swift
//  IOS17
//

import SwiftUI
import TaskCardsData

struct IOS17HomeView: View {
    @State private var viewModel = IOS17ParentViewModel(userId: "demo-user",
                                                             dataSource: TaskCardsDataSource())

    var body: some View {
        IOS17ParentView(viewModel: viewModel)
    }
}
