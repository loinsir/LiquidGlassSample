//
//  SearchDemoView.swift
//  LiquidGlassSample
//
//  검색 바 테스트 화면. 루트 TabView의 Tab(role: .search)에 연결된다.
//

import SwiftUI

struct SearchDemoView: View {
    @State private var searchText = ""
    @State private var minimizeSearch = false

    private let allSymbols: [String] = [
        "heart.fill", "star.fill", "bolt.fill", "cloud.fill", "moon.stars.fill",
        "sun.max.fill", "drop.fill", "flame.fill", "leaf.fill", "snowflake",
        "sparkles", "wind", "tornado", "rainbow", "camera.fill",
        "paperplane.fill", "bell.fill", "bookmark.fill", "tag.fill", "gift.fill",
    ]

    private var filtered: [String] {
        searchText.isEmpty
            ? allSymbols
            : allSymbols.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("검색 필드도 Liquid Glass를 사용합니다. 이 탭은 Tab(role: .search)로 만들어져 탭 바 우측에 돋보기로 분리 표시됩니다.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Toggle("스크롤 시 검색 바 최소화", isOn: $minimizeSearch)
                    Text(minimizeSearch
                         ? ".searchToolbarBehavior(.minimize)"
                         : "Tab(role: .search) { ... } + .searchable(...)")
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }

            Section("SF Symbols (\(filtered.count))") {
                ForEach(filtered, id: \.self) { symbol in
                    Label(symbol, systemImage: symbol)
                }
            }
        }
        .navigationTitle("검색")
        .searchable(text: $searchText, prompt: "심볼 이름 검색")
        .searchToolbarBehavior(minimizeSearch ? .minimize : .automatic)
    }
}

#Preview {
    NavigationStack { SearchDemoView() }
}
