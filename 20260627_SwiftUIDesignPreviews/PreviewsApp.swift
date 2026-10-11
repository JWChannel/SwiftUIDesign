//
//  PreviewsApp.swift
//  20260627_SwiftUIDesignPreviews
//

import SwiftUI

@main
struct PreviewsApp: App {
    @StateObject private var iOS15ViewModel = IOS15PreviewData.parentViewModel(.success(PreviewSampleData.cards))
    @State private var iOS17ViewModel = IOS17PreviewData.parentViewModel(.success(PreviewSampleData.cards))

    var body: some Scene {
        WindowGroup {
            TabView {
                IOS15ParentView(viewModel: iOS15ViewModel)
                    .tabItem { Label("ObservableObject", systemImage: "1.circle") }
                IOS17ParentView(viewModel: iOS17ViewModel)
                    .tabItem { Label("Observable", systemImage: "2.circle") }
            }
        }
    }
}
