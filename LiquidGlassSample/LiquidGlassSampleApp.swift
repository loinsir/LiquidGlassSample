//
//  LiquidGlassSampleApp.swift
//  LiquidGlassSample
//
//  Created by 김인환 on 9/5/26.
//

import SwiftUI

@main
struct LiquidGlassSampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // iPadOS 26 메뉴 바: 화면 상단에서 아래로 스와이프하면
        // Liquid Glass 메뉴 바가 나타난다. (iPhone에서는 표시되지 않음)
        .commands {
            CommandMenu("샘플") {
                Button("새 항목", systemImage: "plus") {}
                    .keyboardShortcut("n")
                Button("공유", systemImage: "square.and.arrow.up") {}
                    .keyboardShortcut("s", modifiers: [.command, .shift])
                Divider()
                Button("새로 고침", systemImage: "arrow.clockwise") {}
                    .keyboardShortcut("r")
            }
        }
    }
}
