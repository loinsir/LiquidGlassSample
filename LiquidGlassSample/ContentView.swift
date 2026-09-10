//
//  ContentView.swift
//  LiquidGlassSample
//
//  Created by 김인환 on 9/5/26.
//
//  디자이너를 위한 Liquid Glass 컴포넌트 레퍼런스.
//  탭 바 자체도 Liquid Glass이며, 아래로 스크롤하면 최소화됩니다.
//

import SwiftUI

struct ContentView: View {
    private enum TabID: Int {
        case basics, buttons, morphing, system, search
    }

    // 스크린샷 자동화용: START_TAB 환경 변수로 시작 탭 지정 가능.
    @State private var selection = Int(ProcessInfo.processInfo.environment["START_TAB"] ?? "") ?? 0

    // 스크린샷 자동화용: START_DEMO 환경 변수로 시스템 탭 하위 화면 딥링크.
    @State private var systemPath: [SystemDemoScreen] = {
        guard let raw = ProcessInfo.processInfo.environment["START_DEMO"],
              let screen = SystemDemoScreen(rawValue: raw) else { return [] }
        return [screen]
    }()

    /// 탭 바를 숨기는 데모(하단 툴바·safeAreaBar)에서는 액세서리가
    /// 해당 화면의 하단 바를 덮어버리므로 함께 비활성화한다.
    private var isBottomAccessoryEnabled: Bool {
        guard selection == TabID.system.rawValue,
              let current = systemPath.last
        else { return true }

        return !current.hidesTabBar
    }

    var body: some View {
        TabView(selection: $selection) {
            Tab("기본", systemImage: "drop.fill", value: TabID.basics.rawValue) {
                NavigationStack { BasicsView() }
            }
            Tab("버튼", systemImage: "button.horizontal.top.press", value: TabID.buttons.rawValue) {
                NavigationStack { ButtonsView() }
            }
            Tab("모핑", systemImage: "circle.hexagongrid.fill", value: TabID.morphing.rawValue) {
                NavigationStack { MorphingView() }
            }
            Tab("시스템", systemImage: "macwindow", value: TabID.system.rawValue) {
                SystemView(path: $systemPath) // 자체 NavigationStack 보유 (딥링크용 path)
            }
            Tab("검색", systemImage: "magnifyingglass", value: TabID.search.rawValue, role: .search) {
                NavigationStack { SearchDemoView() }
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .tabViewBottomAccessory(isEnabled: isBottomAccessoryEnabled) {
            MiniPlayerAccessory()
        }
    }
}

/// 탭 바 위에 떠 있는 하단 액세서리 데모 (뮤직 앱의 미니 플레이어 스타일).
private struct MiniPlayerAccessory: View {
    @State private var isPlaying = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "opticaldisc.fill")
                .font(.title2)
                .foregroundStyle(.tint)
            VStack(alignment: .leading, spacing: 1) {
                Text("Bottom Accessory")
                    .font(.subheadline.weight(.semibold))
                Text(".tabViewBottomAccessory { ... }")
                    .font(.caption2.monospaced())
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button {
                isPlaying.toggle()
            } label: {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
            }
            .buttonStyle(.plain)
            .font(.title3)
        }
        .padding(.horizontal)
    }
}

#Preview {
    ContentView()
}
