//
//  ButtonsView.swift
//  LiquidGlassSample
//
//  Liquid Glass 버튼 스타일 샘플.
//  커스텀 글래스 효과 대신 표준 버튼 스타일 사용이 권장된다.
//  참고: https://developer.apple.com/documentation/technologyoverviews/adopting-liquid-glass
//

import SwiftUI

struct ButtonsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                DemoCard(
                    title: ".glass 버튼 스타일",
                    description: "표준 버튼 스타일로 Liquid Glass의 룩앤필과 인터랙션을 최소한의 코드로 적용합니다.",
                    code: "Button(\"...\") { }.buttonStyle(.glass)",
                    backdropSeed: 0,
                    demoHeight: 160
                ) {
                    HStack(spacing: 16) {
                        Button("Glass") {}
                            .buttonStyle(.glass)
                        Button("Glass", systemImage: "sparkles") {}
                            .buttonStyle(.glass)
                        Button {} label: {
                            Image(systemName: "square.and.arrow.up")
                        }
                        .buttonStyle(.glass)
                    }
                }

                DemoCard(
                    title: ".glassProminent 버튼 스타일",
                    description: "틴트 컬러가 채워진 프로미넌트 글래스 버튼입니다. 화면의 핵심 액션에 사용하세요.",
                    code: ".buttonStyle(.glassProminent).tint(.pink)",
                    backdropSeed: 3,
                    demoHeight: 160
                ) {
                    HStack(spacing: 16) {
                        Button("Continue") {}
                            .buttonStyle(.glassProminent)
                        Button("Buy", systemImage: "cart.fill") {}
                            .buttonStyle(.glassProminent)
                            .tint(.pink)
                    }
                }

                DemoCard(
                    title: "컨트롤 사이즈",
                    description: "mini부터 새로 추가된 extraLarge까지 지원합니다. 레이블과 액센트를 위한 공간이 더 넓어졌습니다.",
                    code: ".controlSize(.extraLarge)",
                    backdropSeed: 2,
                    demoHeight: 300
                ) {
                    VStack(spacing: 14) {
                        ForEach(ControlSizeItem.allCases, id: \.self) { item in
                            Button(item.label) {}
                                .buttonStyle(.glass)
                                .controlSize(item.size)
                        }
                    }
                }

                DemoCard(
                    title: "버튼 모양",
                    description: "buttonBorderShape로 버튼의 셰이프를 조정할 수 있습니다. 하드웨어 곡률과 어울리는 둥근 형태가 기본입니다.",
                    code: ".buttonBorderShape(.roundedRectangle(radius: 14))",
                    backdropSeed: 1,
                    demoHeight: 160
                ) {
                    HStack(spacing: 16) {
                        Button("Capsule") {}
                            .buttonStyle(.glass)
                            .buttonBorderShape(.capsule)
                        Button("Rounded") {}
                            .buttonStyle(.glass)
                            .buttonBorderShape(.roundedRectangle(radius: 14))
                        Button {} label: {
                            Image(systemName: "circle.grid.2x2.fill")
                        }
                        .buttonStyle(.glass)
                        .buttonBorderShape(.circle)
                    }
                }

                DemoCard(
                    title: "버튼 → 메뉴 모핑",
                    description: "표준 컴포넌트를 쓰면 버튼이 메뉴로 유동적으로 모핑됩니다. 눌러보세요.",
                    code: "Menu { ... } label: { ... }.buttonStyle(.glass)",
                    backdropSeed: 0,
                    demoHeight: 180
                ) {
                    Menu {
                        Button("복사", systemImage: "doc.on.doc") {}
                        Button("공유", systemImage: "square.and.arrow.up") {}
                        Divider()
                        Button("삭제", systemImage: "trash", role: .destructive) {}
                    } label: {
                        Label("옵션", systemImage: "ellipsis.circle")
                            .padding(4)
                    }
                    .buttonStyle(.glass)
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("버튼")
    }
}

private enum ControlSizeItem: CaseIterable {
    case mini, small, regular, large, extraLarge

    var size: ControlSize {
        switch self {
        case .mini: .mini
        case .small: .small
        case .regular: .regular
        case .large: .large
        case .extraLarge: .extraLarge
        }
    }

    var label: String {
        switch self {
        case .mini: ".mini"
        case .small: ".small"
        case .regular: ".regular"
        case .large: ".large"
        case .extraLarge: ".extraLarge"
        }
    }
}

#Preview {
    NavigationStack { ButtonsView() }
}
