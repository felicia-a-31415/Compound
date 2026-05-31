import SwiftUI

struct PillarTag: View {
    let pillar: Pillar

    var body: some View {
        Text(pillar.displayName.uppercased())
            .font(.labelSmall)
            .kerning(0.6)
            .foregroundStyle(pillar.color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(pillar.tagBackground)
            .clipShape(RoundedRectangle(cornerRadius: Radius.tag))
    }
}
