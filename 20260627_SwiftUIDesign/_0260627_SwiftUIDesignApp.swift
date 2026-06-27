//
//  _0260627_SwiftUIDesignApp.swift
//  20260627_SwiftUIDesign
//
//  Created by J W on 2026/6/27.
//

import SwiftUI

@main
struct _0260627_SwiftUIDesignApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                ParentView()
                    .tabItem { Label("BaseClass", systemImage: "1.circle") }
                ObservableParentView()
                    .tabItem { Label("Observable", systemImage: "2.circle") }
                EquatableParentView()
                    .tabItem { Label("Equatable", systemImage: "3.circle") }
            }
        }
    }
}
