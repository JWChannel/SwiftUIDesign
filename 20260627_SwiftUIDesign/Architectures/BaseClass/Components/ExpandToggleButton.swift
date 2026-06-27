//
//  ExpandToggleButton.swift
//  20260627_SwiftUIDesign
//

import SwiftUI

struct ExpandToggleButton: View {
    let isExpanded: Bool
    var expandTitle: String = "看更多"
    var collapseTitle: String = "收合"
    let onTapButton: () -> Void

    var body: some View {
        Button {
            withAnimation { onTapButton() }
        } label: {
            HStack(spacing: 4) {
                Text(isExpanded ? collapseTitle : expandTitle)
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
            }
            .font(.subheadline)
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity)
            .padding(.top, 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 24) {
        ExpandToggleButton(isExpanded: false) {}
        ExpandToggleButton(isExpanded: true) {}
        ExpandToggleButton(isExpanded: false, expandTitle: "顯示全部") {}
    }
    .padding()
}
