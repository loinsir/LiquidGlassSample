//
//  DemoCard.swift
//  LiquidGlassSample
//
//  디자이너 참고용 데모 카드 컴포넌트.
//  각 카드는 컬러풀한 배경 위에 Liquid Glass 샘플을 올려
//  글래스의 굴절/블러가 잘 보이도록 구성한다.
//

import SwiftUI

/// 글래스 효과가 잘 드러나도록 하는 컬러풀한 배경.
struct GlassBackdrop: View {
    var seed: Int = 0

    private static let palettes: [[Color]] = [
        [.indigo, .purple, .pink, .orange, .blue, .cyan, .mint, .purple, .indigo],
        [.orange, .pink, .red, .purple, .yellow, .orange, .pink, .indigo, .purple],
        [.teal, .blue, .indigo, .cyan, .mint, .blue, .green, .teal, .indigo],
        [.pink, .purple, .indigo, .orange, .red, .pink, .yellow, .orange, .purple],
    ]

    var body: some View {
        let colors = Self.palettes[seed % Self.palettes.count]
        MeshGradient(
            width: 3, height: 3,
            points: [
                [0, 0], [0.5, 0], [1, 0],
                [0, 0.5], [0.4, 0.6], [1, 0.5],
                [0, 1], [0.5, 1], [1, 1],
            ],
            colors: colors
        )
        .overlay {
            GeometryReader { proxy in
                let size = proxy.size
                ForEach(0..<6, id: \.self) { index in
                    Image(systemName: ["leaf.fill", "sparkles", "cloud.fill", "moon.stars.fill", "sun.max.fill", "drop.fill"][index])
                        .font(.system(size: 40))
                        .foregroundStyle(.white.opacity(0.25))
                        .position(
                            x: size.width * [0.15, 0.85, 0.5, 0.25, 0.75, 0.6][index],
                            y: size.height * [0.2, 0.3, 0.8, 0.65, 0.75, 0.15][index]
                        )
                }
            }
        }
    }
}

/// 제목 + 설명 + 데모 영역 + 사용 API 코드로 구성된 카드.
struct DemoCard<Content: View>: View {
    let title: String
    var description: String? = nil
    var code: String? = nil
    var backdropSeed: Int = 0
    var demoHeight: CGFloat = 180
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                if let description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()

            ZStack {
                GlassBackdrop(seed: backdropSeed)
                content
            }
            .frame(maxWidth: .infinity, minHeight: demoHeight)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 12)

            if let code {
                Text(code)
                    .font(.caption.monospaced())
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
                    .padding(12)
            } else {
                Spacer().frame(height: 12)
            }
        }
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
    }
}

#Preview {
    ScrollView {
        DemoCard(
            title: "기본 글래스 효과",
            description: "기본값은 Capsule 셰이프에 regular 변형입니다.",
            code: ".glassEffect()"
        ) {
            Text("Hello, World!")
                .font(.title)
                .padding()
                .glassEffect()
        }
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}
