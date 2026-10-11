//
//  _0260627_SwiftUIDesignApp.swift
//  20260627_SwiftUIDesign
//
//  Created by J W on 2026/6/27.
//

import SwiftUI

@main
struct _0260627_SwiftUIDesignApp: App {
    @State private var selectedTab = AppTab.launchSelection

    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                IOS15HomeView()
                    .tabItem { Label("ObservableObject", systemImage: "1.circle") }
                    .tag(AppTab.observableObject)
                IOS17HomeView()
                    .tabItem { Label("Observable", systemImage: "2.circle") }
                    .tag(AppTab.observable)
            }
        }
    }
}

enum AppTab: String {
    case observableObject
    case observable

    // Launch argument `-tab observable` opens that tab directly, for simulator screenshots
    static var launchSelection: AppTab {
        #if DEBUG
        if let tab = UserDefaults.standard.string(forKey: "tab").flatMap(AppTab.init(rawValue:)) {
            return tab
        }
        #endif
        return .observableObject
    }
}
