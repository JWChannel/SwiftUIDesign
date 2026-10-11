//
//  ExpandToggleButton.swift
//  Shared
//

import SwiftUI

struct ExpandToggleButton: View {
    let isExpanded: Bool
    var expandTitle: String = "Show more"
    var collapseTitle: String = "Show less"
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

#if Previews
#Preview {
    VStack(spacing: 24) {
        ExpandToggleButton(isExpanded: false) {}
        ExpandToggleButton(isExpanded: true) {}
        ExpandToggleButton(isExpanded: false, expandTitle: "Show all") {}
    }
    .padding()
}
#endif
