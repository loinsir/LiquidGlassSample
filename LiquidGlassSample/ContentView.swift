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
    // 스크린샷 자동화용: START_TAB 환경 변수로 시작 탭 지정 가능.
    @State private var selection = Int(ProcessInfo.processInfo.environment["START_TAB"] ?? "") ?? 0

    var body: some View {
        TabView(selection: $selection) {
            Tab("기본", systemImage: "drop.fill", value: 0) {
                NavigationStack { BasicsView() }
            }
            Tab("버튼", systemImage: "button.horizontal.top.press", value: 1) {
                NavigationStack { ButtonsView() }
            }
            Tab("모핑", systemImage: "circle.hexagongrid.fill", value: 2) {
                NavigationStack { MorphingView() }
            }
            Tab("시스템", systemImage: "macwindow", value: 3) {
                SystemView() // 자체 NavigationStack 보유 (딥링크용 path)
            }
            Tab("검색", systemImage: "magnifyingglass", value: 4, role: .search) {
                NavigationStack { SearchDemoView() }
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .tabViewBottomAccessory {
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
