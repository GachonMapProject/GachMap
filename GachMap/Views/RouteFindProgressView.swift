//
//  RouteFindProgressView.swift
//  GachMap
//
//  Created by 원웅주 on 5/21/24.
//

import SwiftUI
import Combine

class ProgressViewModel: ObservableObject {
    @Published var isShowingProgress: Bool = false
}


struct RouteFindProgressView: View {
    @StateObject private var progressViewModel = ProgressViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                Button(action: {
                    progressViewModel.isShowingProgress = true
                    // Simulate a network request or some task
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        progressViewModel.isShowingProgress = false
                    }
                }) {
                    Text("Show Progress")
                }
            }
            
            if progressViewModel.isShowingProgress {
                ProgressAlertView()
            }
        }
        .environmentObject(progressViewModel)
    }
}

struct ProgressAlertView: View {
    @EnvironmentObject var progressViewModel: ProgressViewModel
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    .scaleEffect(1.5)
                    .padding()
                
                Text("경로 탐색 중")
                    .foregroundColor(.black)
            }
            .frame(width: 200, height: 180)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(15)
            .shadow(radius: 10)
        }
    }
}

#Preview {
    RouteFindProgressView()
}
