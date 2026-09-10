//
//  SystemView.swift
//  LiquidGlassSample
//
//  시스템 컴포넌트 허브. 각 컴포넌트가 자동으로 얻는
//  Liquid Glass 룩앤필을 개별 화면에서 테스트할 수 있다.
//

import SwiftUI

enum SystemDemoScreen: String, CaseIterable, Hashable {
    case navigationBar, toolbar, tabBar, safeAreaBar, controls, presentation, ipadLayout

    var title: String {
        switch self {
        case .navigationBar: "내비게이션 바"
        case .toolbar: "툴바"
        case .tabBar: "탭 바 & 하단 액세서리"
        case .safeAreaBar: "커스텀 바 (safeAreaBar)"
        case .controls: "컨트롤"
        case .presentation: "시트 · 팝오버 · 메뉴 · 알럿"
        case .ipadLayout: "스플릿 뷰 · 배경 확장 · 인스펙터"
        }
    }

    var icon: String {
        switch self {
        case .navigationBar: "rectangle.topthird.inset.filled"
        case .toolbar: "slider.horizontal.below.rectangle"
        case .tabBar: "rectangle.bottomthird.inset.filled"
        case .safeAreaBar: "rectangle.bottomhalf.inset.filled"
        case .controls: "switch.2"
        case .presentation: "rectangle.portrait.on.rectangle.portrait"
        case .ipadLayout: "ipad.landscape"
        }
    }

    /// 탭 바를 숨기고 자체 하단 바를 보여주는 화면인지 여부.
    /// 루트 TabView가 하단 액세서리 표시 여부를 결정할 때 사용한다.
    var hidesTabBar: Bool {
        switch self {
        case .toolbar, .safeAreaBar: true
        default: false
        }
    }

    @ViewBuilder
    var destination: some View {
        switch self {
        case .navigationBar: NavigationBarDemoView()
        case .toolbar: ToolbarDemoView()
        case .tabBar: TabBarInfoView()
        case .safeAreaBar: SafeAreaBarDemoView()
        case .controls: ControlsDemoView()
        case .presentation: PresentationDemoView()
        case .ipadLayout: IPadLayoutDemoView().toolbarVisibility(.hidden, for: .navigationBar)
        }
    }
}

struct SystemView: View {
    // 루트 TabView가 현재 화면에 따라 하단 액세서리를 제어할 수 있도록 path를 외부에서 소유한다.
    @Binding var path: [SystemDemoScreen]

    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("표준 컴포넌트는 자동 적용", systemImage: "wand.and.stars")
                            .font(.headline)
                        Text("바, 시트, 팝오버, 컨트롤 같은 표준 컴포넌트는 별도 코드 없이 Liquid Glass를 자동으로 사용합니다. 아래 화면에서 컴포넌트별로 확인해 보세요.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }

                Section("내비게이션 레이어") {
                    link(.navigationBar)
                    link(.toolbar)
                    link(.tabBar)
                    link(.safeAreaBar)
                }

                Section("입력 & 컨트롤") {
                    link(.controls)
                    link(.presentation)
                }

                Section("iPad") {
                    link(.ipadLayout)
                    Label("iPadOS 메뉴 바: iPad에서 화면 상단을 아래로 스와이프하면 글래스 메뉴 바가 나타납니다 (.commands로 정의).", systemImage: "menubar.rectangle")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Section {
                    Label("검색 바는 탭 바의 검색 탭(돋보기)에서 테스트하세요. Tab(role: .search)로 만든 탭은 탭 바 우측에 분리되어 표시됩니다.", systemImage: "magnifyingglass")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("시스템 컴포넌트")
            .navigationDestination(for: SystemDemoScreen.self) { screen in
                screen.destination
            }
        }
    }

    private func link(_ screen: SystemDemoScreen) -> some View {
        NavigationLink(value: screen) {
            Label(screen.title, systemImage: screen.icon)
        }
    }
}

#Preview {
    @Previewable @State var path: [SystemDemoScreen] = []
    SystemView(path: $path)
}
