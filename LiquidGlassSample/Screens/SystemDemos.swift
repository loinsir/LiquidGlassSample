//
//  SystemDemos.swift
//  LiquidGlassSample
//
//  시스템 컴포넌트별 Liquid Glass 테스트 화면 모음.
//  내비게이션 바 / 툴바 / 탭 바 / 컨트롤 / 프레젠테이션.
//

import SwiftUI

// MARK: - 내비게이션 바

struct NavigationBarDemoView: View {
    @State private var inlineTitle = false
    @State private var hideBar = false
    @State private var scrollEdgeStyle: EdgeStyle = .automatic

    enum EdgeStyle: String, CaseIterable {
        case automatic, soft, hard

        var style: ScrollEdgeEffectStyle? {
            switch self {
            case .automatic: nil
            case .soft: .soft
            case .hard: .hard
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("내비게이션 바는 콘텐츠 위에 떠 있는 Liquid Glass 레이어입니다. 아래로 스크롤해 타이틀이 축소되고 바 아래로 콘텐츠가 비치는 모습을 확인하세요.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                GroupBox("옵션") {
                    Toggle("인라인 타이틀", isOn: $inlineTitle.animation())
                    Toggle("바 숨기기", isOn: $hideBar.animation())
                    Picker("스크롤 엣지 효과", selection: $scrollEdgeStyle) {
                        ForEach(EdgeStyle.allCases, id: \.self) { Text($0.rawValue) }
                    }
                    .pickerStyle(.segmented)
                }

                Text(".scrollEdgeEffectStyle(.\(scrollEdgeStyle.rawValue), for: .top)")
                    .font(.caption.monospaced())
                    .foregroundStyle(.secondary)

                ColorGridContent()
            }
            .padding()
        }
        .scrollEdgeEffectStyle(scrollEdgeStyle.style, for: .top)
        .navigationTitle("내비게이션 바")
        .navigationBarTitleDisplayMode(inlineTitle ? .inline : .large)
        .toolbarVisibility(hideBar ? .hidden : .visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("정보", systemImage: "info.circle") {}
            }
        }
    }
}

// MARK: - 툴바

struct ToolbarDemoView: View {
    @State private var showBottomBar = true
    @State private var isFavorite = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("툴바 아이템은 Liquid Glass 배경을 공유하는 그룹으로 묶입니다. ToolbarSpacer(.fixed)가 상단 우측의 두 그룹을 분리하고 있습니다. 하단 툴바도 확인해 보세요.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                GroupBox("옵션") {
                    Toggle("하단 툴바 표시", isOn: $showBottomBar.animation())
                }

                Text("""
                ToolbarItem(placement: .topBarTrailing) { ... }
                ToolbarSpacer(.fixed, placement: .topBarTrailing)
                ToolbarItemGroup(placement: .bottomBar) { ... }
                ToolbarItem { ... }.sharedBackgroundVisibility(.hidden)
                """)
                .font(.caption.monospaced())
                .foregroundStyle(.secondary)

                Text("상단 좌측의 원형 프로필 아이템은 sharedBackgroundVisibility(.hidden)로 공유 글래스 배경에서 분리되어 있습니다.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                ColorGridContent()
            }
            .padding()
        }
        .navigationTitle("툴바")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarVisibility(.hidden, for: .tabBar) // 하단 툴바가 잘 보이도록 탭 바 숨김
        .toolbar {
            // 공유 글래스 배경에서 분리된 아이템
            ToolbarItem(placement: .topBarLeading) {
                Button {} label: {
                    Image(systemName: "person.crop.circle.fill")
                        .foregroundStyle(.pink)
                }
            }
            .sharedBackgroundVisibility(.hidden)

            ToolbarItem(placement: .topBarTrailing) {
                Button("공유", systemImage: "square.and.arrow.up") {}
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("즐겨찾기", systemImage: isFavorite ? "heart.fill" : "heart") {
                    withAnimation { isFavorite.toggle() }
                }
            }
            ToolbarSpacer(.fixed, placement: .topBarTrailing)
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("복사", systemImage: "doc.on.doc") {}
                    Button("이동", systemImage: "folder") {}
                    Button("삭제", systemImage: "trash", role: .destructive) {}
                } label: {
                    Image(systemName: "ellipsis")
                }
            }

            if showBottomBar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button("작성", systemImage: "square.and.pencil") {}
                    Spacer()
                    Text("항목 24개")
                        .font(.footnote)
                        .fixedSize()
                    Spacer()
                    Button("필터", systemImage: "line.3.horizontal.decrease.circle") {}
                }
            }
        }
    }
}

// MARK: - 커스텀 바 (safeAreaBar)

struct SafeAreaBarDemoView: View {
    @State private var selectedFilter = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("safeAreaBar는 커스텀 바를 위한 API입니다. 시스템 바처럼 세이프 에어리어를 조정하고, 아래로 스크롤되는 콘텐츠에 스크롤 엣지 효과를 적용합니다. 하단의 필터 바가 커스텀 글래스 바입니다.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(".safeAreaBar(edge: .bottom) {\n    ...glassEffect(...)\n}")
                    .font(.caption.monospaced())
                    .foregroundStyle(.secondary)
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 10))

                ColorGridContent()
            }
            .padding()
        }
        .safeAreaBar(edge: .bottom) {
            GlassEffectContainer(spacing: 12) {
                HStack(spacing: 12) {
                    ForEach(Array(["전체", "사진", "동영상"].enumerated()), id: \.offset) { index, name in
                        Button(name) {
                            withAnimation { selectedFilter = index }
                        }
                        .buttonStyle(.glass)
                        .tint(selectedFilter == index ? .blue : nil)
                    }
                    Spacer()
                    Image(systemName: "line.3.horizontal.decrease")
                        .frame(width: 44, height: 44)
                        .glassEffect(.regular.interactive(), in: .circle)
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle("커스텀 바")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarVisibility(.hidden, for: .tabBar) // 커스텀 바가 잘 보이도록 탭 바 숨김
    }
}

// MARK: - 탭 바 안내

struct TabBarInfoView: View {
    @State private var showSidebarAdaptable = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                GroupBox {
                    Label("이 앱의 탭 바가 곧 데모입니다", systemImage: "sparkles")
                        .font(.headline)
                    Text("아래 항목들이 이미 루트 TabView에 적용되어 있습니다. 이 화면에서 아래로 스크롤해 직접 확인해 보세요.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                bullet(
                    title: "탭 바 최소화",
                    detail: "아래로 스크롤하면 탭 바가 축소되어 콘텐츠에 집중하게 합니다. 반대로 스크롤하면 다시 확장됩니다.",
                    code: ".tabBarMinimizeBehavior(.onScrollDown)"
                )
                bullet(
                    title: "하단 액세서리 (미니 플레이어)",
                    detail: "탭 바 위에 떠 있는 글래스 액세서리입니다. 탭 바가 최소화되면 액세서리가 옆으로 이동합니다.",
                    code: ".tabViewBottomAccessory { MiniPlayerView() }"
                )
                bullet(
                    title: "검색 탭",
                    detail: "role: .search를 지정한 탭은 탭 바 우측에 분리된 돋보기로 표시됩니다.",
                    code: "Tab(role: .search) { ... }"
                )

                VStack(alignment: .leading, spacing: 8) {
                    Text("사이드바 적응형 탭 바").font(.headline)
                    Text("iPad에서는 탭 바가 사이드바로 전환될 수 있습니다. 아래 버튼으로 별도 화면에서 확인하세요 (iPhone에서는 일반 탭 바로 표시).")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Button("사이드바 적응형 데모 열기", systemImage: "sidebar.left") {
                        showSidebarAdaptable = true
                    }
                    .buttonStyle(.glassProminent)
                    Text(".tabViewStyle(.sidebarAdaptable)")
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 16))

                ColorGridContent()
            }
            .padding()
        }
        .navigationTitle("탭 바")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $showSidebarAdaptable) {
            SidebarAdaptableDemo()
        }
    }

    private func bullet(title: String, detail: String, code: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.headline)
            Text(detail).font(.subheadline).foregroundStyle(.secondary)
            Text(code)
                .font(.caption.monospaced())
                .foregroundStyle(.secondary)
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 10))
        }
        .padding()
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - 컨트롤

struct ControlsDemoView: View {
    @State private var toggleOn = true
    @State private var sliderValue = 0.6
    @State private var stepperValue = 2
    @State private var segment = 0
    @State private var text = ""
    @State private var date = Date()

    var body: some View {
        Form {
            Section("새로워진 컨트롤") {
                Toggle("토글 — 노브가 글래스로 변형", isOn: $toggleOn)
                VStack(alignment: .leading) {
                    Text("슬라이더 — 드래그 중 노브가 Liquid Glass")
                    Slider(value: $sliderValue)
                }
                Stepper("스테퍼: \(stepperValue)", value: $stepperValue, in: 0...10)
                Picker("세그먼티드 컨트롤", selection: $segment) {
                    Text("하나").tag(0)
                    Text("둘").tag(1)
                    Text("셋").tag(2)
                }
                .pickerStyle(.segmented)
                DatePicker("날짜 선택", selection: $date, displayedComponents: .date)
                TextField("텍스트 필드", text: $text)
            }

            Section("버튼과 결합") {
                LabeledContent("표준 버튼") {
                    Button("Bordered") {}
                        .buttonStyle(.bordered)
                }
                LabeledContent("글래스 버튼") {
                    Button("Glass") {}
                        .buttonStyle(.glass)
                }
            }

            Section("컨트롤 그룹 & 프로그레스") {
                ControlGroup {
                    Button("실행 취소", systemImage: "arrow.uturn.backward") {}
                    Button("다시 실행", systemImage: "arrow.uturn.forward") {}
                    Button("지우기", systemImage: "eraser") {}
                }
                ProgressView(value: sliderValue) {
                    Text("결정형 프로그레스 (슬라이더와 연동)")
                }
                HStack {
                    Text("비결정형 프로그레스")
                    Spacer()
                    ProgressView()
                }
            }

            Section {
                Text("컨트롤을 드래그해 보세요. 슬라이더·토글의 노브가 인터랙션 중에 Liquid Glass로 변하며 하이라이트됩니다.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("컨트롤")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 프레젠테이션

struct PresentationDemoView: View {
    @State private var showSheet = false
    @State private var showPopover = false
    @State private var showAlert = false
    @State private var showDialog = false
    @State private var showFullScreen = false

    var body: some View {
        List {
            Section("프레젠테이션 컴포넌트") {
                Button("시트 (detents)", systemImage: "rectangle.portrait.bottomhalf.inset.filled") {
                    showSheet = true
                }
                Button("팝오버", systemImage: "bubble.middle.top") {
                    showPopover = true
                }
                .popover(isPresented: $showPopover) {
                    VStack(spacing: 12) {
                        Text("팝오버도 Liquid Glass")
                            .font(.headline)
                        Text("presentationCompactAdaptation(.popover)로 iPhone에서도 시트 대신 팝오버로 표시됩니다.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .presentationCompactAdaptation(.popover)
                }
                Button("알럿", systemImage: "exclamationmark.bubble") {
                    showAlert = true
                }
                Button("컨펌 다이얼로그", systemImage: "questionmark.bubble") {
                    showDialog = true
                }
                Button("풀스크린 커버", systemImage: "rectangle.inset.filled") {
                    showFullScreen = true
                }
            }

            Section("컨텍스트 메뉴") {
                Label("길게 눌러보세요 — 프리뷰가 들리며 글래스 메뉴가 나타납니다", systemImage: "hand.tap")
                    .contextMenu {
                        Button("복사", systemImage: "doc.on.doc") {}
                        Button("공유", systemImage: "square.and.arrow.up") {}
                        Divider()
                        Button("삭제", systemImage: "trash", role: .destructive) {}
                    }
            }

            Section("메뉴") {
                Menu {
                    Button("복사", systemImage: "doc.on.doc") {}
                    Button("공유", systemImage: "square.and.arrow.up") {}
                    Menu("더 보기") {
                        Button("복제", systemImage: "plus.square.on.square") {}
                        Button("이름 변경", systemImage: "pencil") {}
                    }
                    Divider()
                    Button("삭제", systemImage: "trash", role: .destructive) {}
                } label: {
                    Label("메뉴 열기 — 버튼이 메뉴로 모핑", systemImage: "ellipsis.circle")
                }
            }
        }
        .navigationTitle("프레젠테이션")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showSheet) {
            SheetContent()
                .presentationDetents([.medium, .large])
        }
        .alert("알럿 타이틀", isPresented: $showAlert) {
            Button("확인") {}
            Button("취소", role: .cancel) {}
        } message: {
            Text("알럿도 새로운 머티리얼을 사용합니다.")
        }
        .confirmationDialog("항목을 삭제할까요?", isPresented: $showDialog, titleVisibility: .visible) {
            Button("삭제", role: .destructive) {}
            Button("취소", role: .cancel) {}
        }
        .fullScreenCover(isPresented: $showFullScreen) {
            ZStack {
                GlassBackdrop(seed: 3)
                    .ignoresSafeArea()
                VStack(spacing: 16) {
                    Text("풀스크린 커버")
                        .font(.title.bold())
                        .padding()
                        .glassEffect(in: .rect(cornerRadius: 20))
                    Button("닫기") { showFullScreen = false }
                        .buttonStyle(.glassProminent)
                }
            }
        }
    }
}

struct SheetContent: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                GlassBackdrop(seed: 2)
                    .ignoresSafeArea()
                VStack(spacing: 16) {
                    Text("시트도 Liquid Glass 머티리얼을 자동으로 사용합니다. 위로 끌어 detent를 바꿔보세요.")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding()
                        .glassEffect(in: .rect(cornerRadius: 16))
                    Button("닫기") { dismiss() }
                        .buttonStyle(.glassProminent)
                }
                .padding()
            }
            .navigationTitle("시트")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - 사이드바 적응형 탭 바 (iPad)

struct SidebarAdaptableDemo: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        TabView {
            Tab("보관함", systemImage: "books.vertical.fill") {
                sampleContent(title: "보관함", seed: 0)
            }
            Tab("둘러보기", systemImage: "safari.fill") {
                sampleContent(title: "둘러보기", seed: 1)
            }
            Tab("최근 항목", systemImage: "clock.fill") {
                sampleContent(title: "최근 항목", seed: 2)
            }
            Tab("보관됨", systemImage: "archivebox.fill") {
                sampleContent(title: "보관됨", seed: 3)
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        // 루트 TabView의 미니 플레이어 액세서리가 환경을 통해 상속되므로 이 데모에서는 끈다.
        .tabViewBottomAccessory(isEnabled: false) { EmptyView() }
    }

    private func sampleContent(title: String, seed: Int) -> some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("iPad에서는 우측 상단 버튼으로 탭 바 ↔ 사이드바를 전환할 수 있습니다. iPhone에서는 일반 탭 바로 동작합니다.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    ColorGridContent()
                }
                .padding()
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("닫기") { dismiss() }
                }
            }
        }
    }
}

// MARK: - iPad 레이아웃 (스플릿 뷰 + 배경 확장 효과)

struct IPadLayoutDemoView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedItem: String? = "배경 확장 효과"
    private let items = ["배경 확장 효과", "사이드바", "인스펙터"]
    @State private var showInspector = false

    var body: some View {
        NavigationSplitView {
            List(items, id: \.self, selection: $selectedItem) { item in
                Label(item, systemImage: "square.split.2x1")
            }
            .navigationTitle("스플릿 뷰")
            // 바깥 NavigationStack의 바를 숨기므로 허브로 돌아갈 뒤로 버튼을 직접 제공한다.
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("뒤로", systemImage: "chevron.left") { dismiss() }
                }
            }
        } detail: {
            ZStack {
                // 배경 확장 효과: 배경이 사이드바/인스펙터 아래로
                // 늘어나 보이게 미러링 + 블러 처리된다. (iPad에서 확인)
                GlassBackdrop(seed: 2)
                    .backgroundExtensionEffect()

                VStack(spacing: 16) {
                    Text(selectedItem ?? "항목 선택")
                        .font(.title2.bold())
                        .padding()
                        .glassEffect(in: .rect(cornerRadius: 16))
                    Text("iPad 가로 모드에서 사이드바가 콘텐츠 위에 떠 있고, 배경이 그 아래로 확장되어 보입니다. iPhone에서는 스택으로 접힙니다.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding()
                        .glassEffect(in: .rect(cornerRadius: 16))
                    Button("인스펙터 토글", systemImage: "sidebar.right") {
                        showInspector.toggle()
                    }
                    .buttonStyle(.glassProminent)
                    Text(".backgroundExtensionEffect()")
                        .font(.caption.monospaced())
                        .padding(8)
                        .glassEffect(in: .capsule)
                }
                .padding()
            }
            .inspector(isPresented: $showInspector) {
                List {
                    Section("인스펙터") {
                        Text("인스펙터 패널도 iPad에서 글래스 레이어로 표시됩니다.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        LabeledContent("항목", value: selectedItem ?? "-")
                    }
                }
            }
            .navigationTitle("iPad 레이아웃")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - 공용 스크롤 콘텐츠

/// 바 아래로 비치는 모습을 확인하기 위한 컬러 그리드.
struct ColorGridContent: View {
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 12)], spacing: 12) {
            ForEach(0..<24, id: \.self) { index in
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(hue: Double(index) / 24, saturation: 0.7, brightness: 0.95),
                                Color(hue: Double(index + 3) / 24, saturation: 0.8, brightness: 0.8),
                            ],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 100)
                    .overlay {
                        Text("\(index + 1)")
                            .font(.headline)
                            .foregroundStyle(.white)
                    }
            }
        }
    }
}

#Preview("내비게이션 바") {
    NavigationStack { NavigationBarDemoView() }
}

#Preview("툴바") {
    NavigationStack { ToolbarDemoView() }
}

#Preview("컨트롤") {
    NavigationStack { ControlsDemoView() }
}

#Preview("프레젠테이션") {
    NavigationStack { PresentationDemoView() }
}
