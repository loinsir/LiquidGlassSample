# LiquidGlassSample

디자이너를 위한 iOS 26 **Liquid Glass** 컴포넌트 레퍼런스 앱입니다.
애플 공식 문서를 기반으로 각 API의 실제 렌더링과 인터랙션을 직접 확인할 수 있습니다.

> 요구 사항: Xcode 26 + iOS 26 시뮬레이터/기기

## 화면 구성

| 탭 | 내용 | 핵심 API |
|---|---|---|
| 기본 | 기본 효과, 셰이프, 동심원 셰이프, regular/clear, 틴트, 인터랙티브, 플레이그라운드 | `.glassEffect(_:in:)`, `Glass.regular/.clear`, `.tint()`, `.interactive()`, `ConcentricRectangle`, `.containerShape` |
| 버튼 | 글래스 버튼 스타일, 사이즈, 셰이프, 메뉴 모핑 | `.buttonStyle(.glass)`, `.buttonStyle(.glassProminent)`, `.controlSize`, `.buttonBorderShape` |
| 모핑 | 셰이프 블렌딩(spacing 조절), 유니온, 확장/축소 모핑, materialize 전환 | `GlassEffectContainer(spacing:)`, `.glassEffectUnion(id:namespace:)`, `.glassEffectID(_:in:)`, `.glassEffectTransition(.matchedGeometry/.materialize)` |
| 시스템 | 컴포넌트별 테스트 허브 (아래 표) | — |
| 검색 | 검색 탭 + 검색 필드, 스크롤 시 최소화 | `Tab(role: .search)`, `.searchable`, `.searchToolbarBehavior(.minimize)` |

### 시스템 탭 하위 화면

| 화면 | 내용 | 핵심 API |
|---|---|---|
| 내비게이션 바 | 라지/인라인 타이틀, 바 숨김, 스크롤 엣지 효과 | `.navigationBarTitleDisplayMode`, `.toolbarVisibility`, `.scrollEdgeEffectStyle(_:for:)` |
| 툴바 | 아이템 그룹핑, 고정 스페이서, 하단 툴바, 공유 배경 분리 | `ToolbarItem`, `ToolbarSpacer(.fixed)`, `ToolbarItemGroup(placement: .bottomBar)`, `.sharedBackgroundVisibility(.hidden)` |
| 탭 바 & 하단 액세서리 | 스크롤 시 최소화, 미니 플레이어 액세서리, 검색 탭 분리, 사이드바 적응형 | `.tabBarMinimizeBehavior(.onScrollDown)`, `.tabViewBottomAccessory`, `.tabViewStyle(.sidebarAdaptable)` |
| 커스텀 바 | 커스텀 글래스 바 + 세이프 에어리어/스크롤 엣지 효과 | `.safeAreaBar(edge: .bottom)` |
| 컨트롤 | 토글·슬라이더·스테퍼·세그먼트·데이트피커·컨트롤 그룹·프로그레스 | 표준 컨트롤 (자동 적용), `ControlGroup`, `ProgressView` |
| 시트 · 팝오버 · 메뉴 · 알럿 | 프레젠테이션 컴포넌트의 글래스 머티리얼 | `.sheet` + `presentationDetents`, `.popover`, `Menu`, `.contextMenu`, `.alert`, `.confirmationDialog`, `.fullScreenCover` |
| 스플릿 뷰 · 배경 확장 · 인스펙터 (iPad) | 플로팅 사이드바, 배경 확장 효과, 인스펙터 패널 | `NavigationSplitView`, `.backgroundExtensionEffect()`, `.inspector` |

iPadOS 메뉴 바는 앱 Scene의 `.commands { CommandMenu(...) }`로 정의되어 있으며, iPad에서 화면 상단을 아래로 스와이프하면 나타납니다.

## 디자인 가이드 요약 (공식 문서 기준)

- **표준 컴포넌트 우선** — 바, 시트, 팝오버, 컨트롤은 Liquid Glass를 자동으로 사용합니다. 커스텀 글래스는 최소한으로.
- **글래스 남용 금지** — 글래스는 콘텐츠 위 내비게이션 레이어를 위한 머티리얼입니다. 핵심 기능 요소에만 제한적으로 사용하세요.
- **regular vs clear** — `regular`가 기본. `clear`는 미디어처럼 진한 배경 위 오버레이용.
- **틴트는 프로미넌스 표현용** — 장식이 아니라 중요도를 나타낼 때만.
- **접근성 테스트 필수** — 투명도 감소/모션 감소 설정에서 시스템이 효과를 조정합니다.

## 참고 문서

- [Applying Liquid Glass to custom views](https://developer.apple.com/documentation/swiftui/applying-liquid-glass-to-custom-views)
- [Adopting Liquid Glass](https://developer.apple.com/documentation/technologyoverviews/adopting-liquid-glass)
- [GlassEffectContainer](https://developer.apple.com/documentation/swiftui/glasseffectcontainer)
- [Glass](https://developer.apple.com/documentation/swiftui/glass)

## 스크린샷 자동화

`START_TAB`(0~4)으로 시작 탭을, `START_DEMO`로 시스템 탭 하위 화면을 지정할 수 있습니다
(`navigationBar`, `toolbar`, `tabBar`, `safeAreaBar`, `controls`, `presentation`, `ipadLayout`):

```bash
SIMCTL_CHILD_START_TAB=3 SIMCTL_CHILD_START_DEMO=toolbar xcrun simctl launch booted com.loinsir.LiquidGlassSample
```
