//
//  MorphingView.swift
//  LiquidGlassSample
//
//  GlassEffectContainer를 이용한 블렌딩·유니온·모핑 샘플.
//  참고: https://developer.apple.com/documentation/swiftui/glasseffectcontainer
//

import SwiftUI

struct MorphingView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                BlendingCard()
                UnionCard()
                MorphTransitionCard()
                MaterializeCard()
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("컨테이너 & 모핑")
    }
}

/// 컨테이너 spacing에 따라 인접한 글래스 셰이프가 서로 블렌딩되는 데모.
private struct BlendingCard: View {
    @State private var spacing: CGFloat = 40
    @State private var offset: CGFloat = -20

    var body: some View {
        DemoCard(
            title: "셰이프 블렌딩",
            description: "GlassEffectContainer 안에서 셰이프가 가까워지면 물방울처럼 서로 붙습니다. spacing이 클수록 더 일찍 블렌딩됩니다.",
            code: "GlassEffectContainer(spacing: \(Int(spacing))) { ... }",
            backdropSeed: 2,
            demoHeight: 180
        ) {
            GlassEffectContainer(spacing: spacing) {
                HStack(spacing: 40) {
                    Image(systemName: "scribble.variable")
                        .frame(width: 80, height: 80)
                        .font(.system(size: 36))
                        .glassEffect()

                    Image(systemName: "eraser.fill")
                        .frame(width: 80, height: 80)
                        .font(.system(size: 36))
                        .glassEffect()
                        .offset(x: offset)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 8) {
                LabeledContent("컨테이너 spacing: \(Int(spacing))") {
                    Slider(value: $spacing, in: 0...80)
                }
                LabeledContent("오프셋: \(Int(offset))") {
                    Slider(value: $offset, in: -80...0)
                }
            }
            .font(.subheadline)
            .padding()
            .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 24))
            .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
            .padding(.top, 8)
        }
    }
}

/// glassEffectUnion으로 여러 뷰를 하나의 글래스 셰이프로 합치는 데모.
private struct UnionCard: View {
    @Namespace private var namespace
    private let symbols = ["cloud.bolt.rain.fill", "sun.rain.fill", "moon.stars.fill", "moon.fill"]

    var body: some View {
        DemoCard(
            title: "글래스 유니온",
            description: "같은 ID를 가진 효과들은 정지 상태에서도 하나의 글래스 캡슐로 합쳐집니다. 앞 2개와 뒤 2개가 각각 묶여 있습니다.",
            code: ".glassEffectUnion(id: item < 2 ? \"1\" : \"2\", namespace: namespace)",
            backdropSeed: 0,
            demoHeight: 160
        ) {
            GlassEffectContainer(spacing: 20) {
                HStack(spacing: 20) {
                    ForEach(symbols.indices, id: \.self) { item in
                        Image(systemName: symbols[item])
                            .frame(width: 64, height: 64)
                            .font(.system(size: 28))
                            .glassEffect()
                            .glassEffectUnion(id: item < 2 ? "1" : "2", namespace: namespace)
                    }
                }
            }
        }
    }
}

/// glassEffectID + matchedGeometry 전환으로 확장/축소 시 모핑되는 데모.
private struct MorphTransitionCard: View {
    @State private var isExpanded = false
    @Namespace private var namespace
    private let tools = ["eraser.fill", "highlighter", "lasso"]

    var body: some View {
        DemoCard(
            title: "모핑 트랜지션",
            description: "glassEffectID로 각 효과에 고유 ID를 부여하면 뷰가 나타나고 사라질 때 글래스가 서로에게서 흘러나오듯 모핑됩니다.",
            code: ".glassEffectID(\"pencil\", in: namespace)\n.glassEffectTransition(.matchedGeometry)",
            backdropSeed: 3,
            demoHeight: 200
        ) {
            VStack(spacing: 24) {
                GlassEffectContainer(spacing: 30) {
                    HStack(spacing: 24) {
                        Image(systemName: "pencil")
                            .frame(width: 64, height: 64)
                            .font(.system(size: 28))
                            .glassEffect()
                            .glassEffectID("pencil", in: namespace)

                        if isExpanded {
                            ForEach(tools, id: \.self) { tool in
                                Image(systemName: tool)
                                    .frame(width: 64, height: 64)
                                    .font(.system(size: 28))
                                    .glassEffect()
                                    .glassEffectID(tool, in: namespace)
                                    .glassEffectTransition(.matchedGeometry)
                            }
                        }
                    }
                }

                Button(isExpanded ? "접기" : "펼치기") {
                    withAnimation(.smooth(duration: 0.5)) {
                        isExpanded.toggle()
                    }
                }
                .buttonStyle(.glassProminent)
            }
        }
    }
}

/// materialize 전환: 컨테이너 spacing보다 멀리 떨어진 요소가
/// 나타나거나 사라질 때 사용하는 전환.
private struct MaterializeCard: View {
    @State private var showDistant = false
    @Namespace private var namespace

    var body: some View {
        DemoCard(
            title: "Materialize 트랜지션",
            description: "컨테이너 spacing보다 멀리 떨어진 요소를 추가/제거할 때는 matchedGeometry 대신 materialize 전환을 사용합니다. 글래스가 그 자리에서 생성/소멸됩니다.",
            code: ".glassEffectTransition(.materialize)",
            backdropSeed: 1,
            demoHeight: 200
        ) {
            VStack(spacing: 24) {
                GlassEffectContainer(spacing: 20) {
                    HStack(spacing: 100) {
                        Image(systemName: "bell.fill")
                            .frame(width: 64, height: 64)
                            .font(.system(size: 28))
                            .glassEffect()
                            .glassEffectID("bell", in: namespace)

                        if showDistant {
                            Image(systemName: "bell.badge.fill")
                                .frame(width: 64, height: 64)
                                .font(.system(size: 28))
                                .glassEffect()
                                .glassEffectID("badge", in: namespace)
                                .glassEffectTransition(.materialize)
                        }
                    }
                }

                Button(showDistant ? "제거" : "멀리 떨어진 요소 추가") {
                    withAnimation(.smooth(duration: 0.5)) {
                        showDistant.toggle()
                    }
                }
                .buttonStyle(.glassProminent)
            }
        }
    }
}

#Preview {
    NavigationStack { MorphingView() }
}
