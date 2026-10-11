//
//  IOS15HomeView.swift
//  IOS15
//

import SwiftUI
import TaskCardsData

struct IOS15HomeView: View {
    @StateObject private var viewModel = IOS15ParentViewModel(userId: "demo-user",
                                                                         dataSource: TaskCardsDataSource())

    var body: some View {
        IOS15ParentView(viewModel: viewModel)
    }
}
