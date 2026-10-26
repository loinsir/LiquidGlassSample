//
//  SearchDemoView.swift
//  LiquidGlassSample
//
//  검색 바 테스트 화면. 루트 TabView의 Tab(role: .search)에 연결된다.
//  검색 필드 토큰(.searchable(tokens:)) 예제도 함께 확인할 수 있다.
//

import SwiftUI

/// 검색 필드 토큰으로 쓰이는 심볼 카테고리.
/// searchCompletion(_:)에 토큰을 넘기려면 Identifiable이어야 한다.
enum SymbolCategory: String, CaseIterable, Identifiable {
    case weather, nature, object

    var id: Self { self }

    var title: String {
        switch self {
        case .weather: "날씨"
        case .nature: "자연"
        case .object: "사물"
        }
    }

    var systemImage: String {
        switch self {
        case .weather: "cloud.sun.fill"
        case .nature: "leaf.fill"
        case .object: "shippingbox.fill"
        }
    }
}

struct SearchDemoView: View {
    /// 토큰 추천 방식.
    private enum SuggestionMode: String, CaseIterable, Identifiable {
        case suggestedTokens, searchSuggestions, editableTokens

        var id: Self { self }

        var title: String {
            switch self {
            case .suggestedTokens: "추천 토큰"
            case .searchSuggestions: "입력 중 추천"
            case .editableTokens: "편집 토큰"
            }
        }

        var code: String {
            switch self {
            case .suggestedTokens:
                ".searchable(text:tokens:suggestedTokens:prompt:token:)"
            case .searchSuggestions:
                ".searchable(text:tokens:prompt:token:)\n.searchSuggestions { Text(...).searchCompletion(token) }"
            case .editableTokens:
                ".searchable(text:editableTokens:prompt:) { $token in Picker(...) }\n.searchSuggestions { Text(...).searchCompletion(token) }"
            }
        }

        var description: String {
            switch self {
            case .suggestedTokens:
                "필드를 탭했고 입력이 비어 있을 때만 필드 아래에 목록 행으로 뜹니다. 토큰이 하나라도 들어가면 목록이 사라집니다."
            case .searchSuggestions:
                "입력 중이거나 토큰이 이미 있어도 추천을 계속 띄울 수 있어 토큰을 여러 개 고를 수 있습니다."
            case .editableTokens:
                "토큰 클로저가 Binding을 받아 토큰 안 컨트롤로 값을 바꾸도록 만든 API입니다 (iOS 17+). 하지만 iOS에서는 토큰 안 Picker가 라벨만 회색 캡슐로 그려지고, 탭하면 토큰이 선택될 뿐 메뉴가 뜨지 않습니다. suggestedTokens 오버로드가 없어 추천은 searchSuggestions로 띄웁니다."
            }
        }
    }

    /// editableTokens용 토큰. 카테고리를 바꿔도 identity가 유지되도록 id를 따로 둔다.
    private struct EditableCategoryToken: Identifiable {
        let id = UUID()
        var category: SymbolCategory
    }

    private struct TokenSearchModifier: ViewModifier {
        @Binding var searchText: String
        @Binding var tokens: [SymbolCategory]
        @Binding var editableTokens: [EditableCategoryToken]
        let suggestionMode: SuggestionMode
        let completionCategories: [SymbolCategory]
        let usesCustomTokenView: Bool

        func body(content: Content) -> some View {
            switch suggestionMode {
            case .suggestedTokens:
                content
                    .searchable(
                        text: $searchText,
                        tokens: $tokens,
                        suggestedTokens: .constant(SymbolCategory.allCases),
                        prompt: "심볼 이름 검색",
                        token: tokenView
                    )
            case .searchSuggestions:
                content
                    .searchable(
                        text: $searchText,
                        tokens: $tokens,
                        prompt: "심볼 이름 검색",
                        token: tokenView
                    )
                    .searchSuggestions {
                        ForEach(completionCategories) { category in
                            Label(category.title, systemImage: category.systemImage)
                                .searchCompletion(category)
                        }
                    }
            case .editableTokens:
                content
                    .searchable(
                        text: $searchText,
                        editableTokens: $editableTokens,
                        prompt: "심볼 이름 검색"
                    ) { $token in
                        Picker(selection: $token.category) {
                            ForEach(SymbolCategory.allCases) { category in
                                Label(category.title, systemImage: category.systemImage)
                                    .tag(category)
                            }
                        } label: {
                            Label(token.category.title, systemImage: token.category.systemImage)
                        }
                    }
                    .searchSuggestions {
                        ForEach(completionCategories) { category in
                            Label(category.title, systemImage: category.systemImage)
                                .searchCompletion(EditableCategoryToken(category: category))
                        }
                    }
            }
        }

        @ViewBuilder
        private func tokenView(_ token: SymbolCategory) -> some View {
            if usesCustomTokenView {
                // 레이아웃·색·배경·테두리 수정자는 모두 무시되고
                // 첫 Text·Image만 꺼내 시스템 회색 캡슐로 다시 그려진다.
                HStack(spacing: 4) {
                    Text(token.title)
                        .bold()
                    Image(systemName: "xmark")
                }
                .foregroundStyle(.red)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(.yellow, in: .capsule)
                .overlay {
                    Capsule().stroke(.primary, lineWidth: 1)
                }
            } else {
                Label(token.title, systemImage: token.systemImage)
            }
        }
    }

    private struct SymbolItem: Identifiable {
        let name: String
        let category: SymbolCategory

        var id: String { name }
    }

    @State private var searchText = ""
    @State private var minimizeSearch = false
    @State private var tokens: [SymbolCategory] = []
    @State private var editableTokens: [EditableCategoryToken] = []
    @State private var suggestionMode: SuggestionMode = .suggestedTokens
    @State private var usesCustomTokenView = false

    private let allSymbols: [SymbolItem] = [
        SymbolItem(name: "heart.fill", category: .object),
        SymbolItem(name: "star.fill", category: .nature),
        SymbolItem(name: "bolt.fill", category: .weather),
        SymbolItem(name: "cloud.fill", category: .weather),
        SymbolItem(name: "moon.stars.fill", category: .nature),
        SymbolItem(name: "sun.max.fill", category: .weather),
        SymbolItem(name: "drop.fill", category: .nature),
        SymbolItem(name: "flame.fill", category: .nature),
        SymbolItem(name: "leaf.fill", category: .nature),
        SymbolItem(name: "snowflake", category: .weather),
        SymbolItem(name: "sparkles", category: .nature),
        SymbolItem(name: "wind", category: .weather),
        SymbolItem(name: "tornado", category: .weather),
        SymbolItem(name: "rainbow", category: .weather),
        SymbolItem(name: "camera.fill", category: .object),
        SymbolItem(name: "paperplane.fill", category: .object),
        SymbolItem(name: "bell.fill", category: .object),
        SymbolItem(name: "bookmark.fill", category: .object),
        SymbolItem(name: "tag.fill", category: .object),
        SymbolItem(name: "gift.fill", category: .object),
    ]

    /// 현재 모드에서 필드에 들어가 있는 토큰의 카테고리.
    private var selectedCategories: [SymbolCategory] {
        suggestionMode == .editableTokens ? editableTokens.map(\.category) : tokens
    }

    private var filtered: [SymbolItem] {
        let categories = selectedCategories
        return allSymbols.filter { item in
            let matchesToken = categories.isEmpty || categories.contains(item.category)
            let matchesText = searchText.isEmpty || item.name.localizedCaseInsensitiveContains(searchText)
            return matchesToken && matchesText
        }
    }

    /// searchSuggestions 모드에서 아직 고르지 않았고 입력어와 맞는 카테고리 (한글 이름·영문 키 모두 매칭).
    private var completionCategories: [SymbolCategory] {
        SymbolCategory.allCases.filter { category in
            let matchesText = searchText.isEmpty
                || category.title.localizedCaseInsensitiveContains(searchText)
                || category.rawValue.localizedCaseInsensitiveContains(searchText)
            return !selectedCategories.contains(category) && matchesText
        }
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

            tokenSection

            Section("SF Symbols (\(filtered.count))") {
                ForEach(filtered) { item in
                    Label(item.name, systemImage: item.name)
                }
            }
        }
        .navigationTitle("검색")
        .modifier(tokenSearchModifier)
        .searchToolbarBehavior(minimizeSearch ? .minimize : .automatic)
    }

    /// suggestedTokens: 오버로드를 쓰면 빈 배열이어도 searchSuggestions가 표시되지 않으므로
    /// 모드별로 .searchable 시그니처를 나눠 적용한다. 토큰·입력값은 이 뷰의 @State라 모드를 바꿔도 유지된다.
    private var tokenSearchModifier: TokenSearchModifier {
        TokenSearchModifier(
            searchText: $searchText,
            tokens: $tokens,
            editableTokens: $editableTokens,
            suggestionMode: suggestionMode,
            completionCategories: completionCategories,
            usesCustomTokenView: usesCustomTokenView
        )
    }

    private var tokenSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Picker("추천 방식", selection: $suggestionMode) {
                    ForEach(SuggestionMode.allCases) { mode in
                        Text(mode.title).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                Text(suggestionMode.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(suggestionMode.code)
                    .font(.caption.monospaced())
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)

            VStack(alignment: .leading, spacing: 8) {
                Toggle("토큰 뷰에 수정자 적용", isOn: $usesCustomTokenView)
                Text(usesCustomTokenView
                     ? "suggestedTokens 목록 행에는 뷰가 그대로 그려지지만, 필드 안 토큰은 bold·빨간 글자·노란 배경·테두리가 모두 무시되고 첫 Text·Image만 시스템 회색 캡슐로 그려집니다. 이미지는 텍스트 앞으로 이동합니다."
                     : "토큰 뷰는 Label(title, systemImage:)이 기준입니다. 아이콘은 텍스트와 같은 단색으로 그려집니다.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)

            HStack {
                Text(selectedCategories.isEmpty ? "선택된 토큰 없음" : selectedCategories.map(\.title).joined(separator: ", "))
                    .foregroundStyle(selectedCategories.isEmpty ? .secondary : .primary)
                Spacer()
                Button("모두 지우기", role: .destructive) {
                    tokens.removeAll()
                    editableTokens.removeAll()
                }
                .disabled(selectedCategories.isEmpty)
            }
        } header: {
            Text("검색 토큰")
        } footer: {
            Text("토큰이 있으면 placeholder가 숨겨지고, 토큰 안에는 × 버튼이 없습니다. 삭제는 토큰 선택 후 백스페이스 또는 필드의 전체 지우기 버튼으로 합니다.")
        }
    }
}

#Preview {
    NavigationStack { SearchDemoView() }
}
