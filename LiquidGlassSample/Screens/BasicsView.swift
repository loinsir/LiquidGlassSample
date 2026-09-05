//
//  BasicsView.swift
//  LiquidGlassSample
//
//  glassEffect 모디파이어의 기본 사용법.
//  참고: https://developer.apple.com/documentation/swiftui/applying-liquid-glass-to-custom-views
//

import SwiftUI

struct BasicsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                DemoCard(
                    title: "기본 글래스 효과",
                    description: "아무 옵션 없이 적용하면 regular 변형이 Capsule 셰이프로 적용됩니다.",
                    code: ".glassEffect()",
                    backdropSeed: 0
                ) {
                    Text("Hello, World!")
                        .font(.title)
                        .padding()
                        .glassEffect()
                }

                DemoCard(
                    title: "커스텀 셰이프",
                    description: "in: 파라미터로 원하는 셰이프를 지정할 수 있습니다. 큰 컴포넌트에는 둥근 사각형을 권장합니다.",
                    code: ".glassEffect(in: .rect(cornerRadius: 16))",
                    backdropSeed: 1,
                    demoHeight: 220
                ) {
                    VStack(spacing: 16) {
                        Text("Rounded Rect")
                            .padding()
                            .glassEffect(in: .rect(cornerRadius: 16))
                        HStack(spacing: 16) {
                            Image(systemName: "heart.fill")
                                .font(.title2)
                                .frame(width: 56, height: 56)
                                .glassEffect(in: .circle)
                            Text("Capsule")
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .glassEffect(in: .capsule)
                        }
                    }
                }

                DemoCard(
                    title: "동심원 셰이프 (Concentric)",
                    description: "ConcentricRectangle은 컨테이너의 코너와 중심을 공유하는 코너를 자동 계산합니다. 컨트롤의 곡률을 컨테이너·하드웨어와 맞추는 것이 Liquid Glass 디자인의 핵심 원칙입니다.",
                    code: ".containerShape(.rect(cornerRadius: 32)) // 부모\n.glassEffect(in: ConcentricRectangle(\n    corners: .concentric(minimum: .fixed(8)), isUniform: true))",
                    backdropSeed: 2,
                    demoHeight: 220
                ) {
                    // 바깥 컨테이너: cornerRadius 32의 둥근 사각형
                    VStack {
                        Text("컨테이너 (r=32)")
                            .font(.caption)
                            .foregroundStyle(.white)
                        Spacer()
                        Text("Concentric")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .glassEffect(in: ConcentricRectangle(corners: .concentric(minimum: .fixed(8)), isUniform: true))
                    }
                    .padding(12)
                    .frame(width: 260, height: 160)
                    .background(.white.opacity(0.15), in: RoundedRectangle(cornerRadius: 32))
                    .containerShape(.rect(cornerRadius: 32))
                }

                DemoCard(
                    title: "regular vs clear",
                    description: "regular는 배경을 흐리며 밝기를 적응시키고, clear는 더 투명해 미디어 위 오버레이에 적합합니다.",
                    code: ".glassEffect(.regular)  /  .glassEffect(.clear)",
                    backdropSeed: 2,
                    demoHeight: 200
                ) {
                    HStack(spacing: 24) {
                        Text(".regular")
                            .padding()
                            .glassEffect(.regular)
                        Text(".clear")
                            .padding()
                            .glassEffect(.clear)
                    }
                    .font(.headline)
                }

                DemoCard(
                    title: "틴트 컬러",
                    description: "tint로 컴포넌트의 중요도(프로미넌스)를 표현합니다. 남용하지 말고 핵심 액션에만 사용하세요.",
                    code: ".glassEffect(.regular.tint(.orange))",
                    backdropSeed: 3,
                    demoHeight: 200
                ) {
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            ForEach([Color.orange, .pink, .blue], id: \.self) { color in
                                Text("Tint")
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                    .glassEffect(.regular.tint(color))
                            }
                        }
                        Text("틴트는 라이트/다크 모두에서 대비를 확인하세요")
                            .font(.caption)
                            .foregroundStyle(.white)
                    }
                }

                DemoCard(
                    title: "인터랙티브",
                    description: "터치와 포인터 인터랙션에 반응합니다. 눌러보세요 — 표준 버튼과 동일한 유동적인 반응을 보입니다.",
                    code: ".glassEffect(.regular.tint(.orange).interactive())",
                    backdropSeed: 0,
                    demoHeight: 200
                ) {
                    InteractiveDemo()
                }

                PlaygroundCard()
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("기본")
    }
}

private struct InteractiveDemo: View {
    @State private var tapCount = 0

    var body: some View {
        VStack(spacing: 12) {
            Text("Tap me!")
                .font(.title2)
                .padding()
                .glassEffect(.regular.tint(.orange).interactive())
                .onTapGesture { tapCount += 1 }
            if tapCount > 0 {
                Text("탭 \(tapCount)회")
                    .font(.caption)
                    .foregroundStyle(.white)
            }
        }
    }
}

/// 옵션을 실시간으로 조합해 볼 수 있는 플레이그라운드.
private struct PlaygroundCard: View {
    private enum Variant: String, CaseIterable {
        case regular, clear
    }
    private enum DemoShape: String, CaseIterable {
        case capsule = "Capsule"
        case rect = "Rect(16)"
        case circle = "Circle"
    }

    @State private var variant: Variant = .regular
    @State private var shape: DemoShape = .capsule
    @State private var tinted = false
    @State private var tintColor: Color = .orange
    @State private var interactive = false

    private var glass: Glass {
        var glass: Glass = variant == .regular ? .regular : .clear
        if tinted { glass = glass.tint(tintColor) }
        if interactive { glass = glass.interactive() }
        return glass
    }

    private var codeText: String {
        var text = ".glassEffect(.\(variant.rawValue)"
        if tinted { text += ".tint(...)" }
        if interactive { text += ".interactive()" }
        text += shape == .capsule ? ")" : (shape == .rect ? ", in: .rect(cornerRadius: 16))" : ", in: .circle)")
        return text
    }

    var body: some View {
        DemoCard(
            title: "플레이그라운드",
            description: "옵션을 조합하며 글래스 스타일을 직접 실험해 보세요.",
            code: codeText,
            backdropSeed: 1,
            demoHeight: 180
        ) {
            Group {
                switch shape {
                case .capsule:
                    Text("Liquid Glass")
                        .font(.title2)
                        .padding()
                        .glassEffect(glass)
                case .rect:
                    Text("Liquid Glass")
                        .font(.title2)
                        .padding()
                        .glassEffect(glass, in: .rect(cornerRadius: 16))
                case .circle:
                    Image(systemName: "drop.fill")
                        .font(.title)
                        .frame(width: 80, height: 80)
                        .glassEffect(glass, in: .circle)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {
                Picker("변형", selection: $variant) {
                    ForEach(Variant.allCases, id: \.self) { Text(".\($0.rawValue)") }
                }
                .pickerStyle(.segmented)

                Picker("셰이프", selection: $shape) {
                    ForEach(DemoShape.allCases, id: \.self) { Text($0.rawValue) }
                }
                .pickerStyle(.segmented)

                HStack {
                    Toggle("틴트", isOn: $tinted.animation())
                    if tinted {
                        ColorPicker("", selection: $tintColor)
                            .labelsHidden()
                    }
                }
                Toggle("인터랙티브", isOn: $interactive)
            }
            .padding()
            .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 24))
            .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
            .padding(.top, 8)
        }
    }
}

#Preview {
    NavigationStack { BasicsView() }
}
