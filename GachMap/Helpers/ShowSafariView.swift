//
//  ShowSafariView.swift
//  GachMap
//
//  Created by 원웅주 on 5/16/24.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        // 업데이트가 필요 없는 간단한 경우로 여기는 비워둡니다.
    }
}
