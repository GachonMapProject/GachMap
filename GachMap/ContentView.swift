//
//  ContentView.swift
//  GachonMap
//
//  Created by 이수현 on 4/9/24.
//

import SwiftUI

struct ContentView: View {
  
  @State private var showSheet: Bool = false
  @State private var selectedTab = 1
    
    init() {
        UITabBar.appearance().scrollEdgeAppearance = .init()
    }
  
  var body: some View {
      TabView(selection: $selectedTab) {
          MapTabView()
              .tabItem {
                  Image(systemName: "map")
                  Text("지도")
              }.tag(1)
              .onAppear() {
                  if selectedTab == 1 {
                      showSheet = true
                  } else {
                      showSheet = false
                  }
              }
          
          BuildingTabView()
              .tabItem {
                  Image(systemName: "building.2")
                  Text("캠퍼스 맵")
              }.tag(2)
              .onAppear() {
                  if selectedTab == 1 {
                      showSheet = true
                  } else {
                      showSheet = false
                  }
              }
          
          EventTabView()
              .tabItem {
                  Image(systemName: "calendar")
                  Text("교내 행사")
              }.tag(3)
              .onAppear() {
                  if selectedTab == 1 {
                      showSheet = true
                  } else {
                      showSheet = false
                  }
              }
          
          ProfileTabView()
              .tabItem {
                  Image(systemName: "person")
                  Text("내 정보")
              }.tag(4)
              .onAppear() {
                  if selectedTab == 1 {
                      showSheet = true
                  } else {
                      showSheet = false
                  }
              }
    }
//    .onAppear() {
//      if selectedTab == 1 {
//        showSheet = true
//      } else {
//        showSheet = false
//      }
//    }
    .ignoresSafeArea()
    .sheet(isPresented: $showSheet) {
      ScrollView(.vertical, content: {
        VStack(alignment: .leading, spacing: 15, content: {
          DashboardView()
        })
        .padding()
      })
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .presentationDetents([.height(70), .medium, .large])
      .presentationCornerRadius(20)
      .presentationBackground(.regularMaterial)
      .presentationBackgroundInteraction(.enabled(upThrough: .large))
      .interactiveDismissDisabled()
      .bottomMaskForSheet()
    }
  }
}

#Preview {
  ContentView()
}

