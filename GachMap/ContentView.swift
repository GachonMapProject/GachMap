//
//  ContentView.swift
//  GachonMap
//
//  Created by 이수현 on 4/9/24.
//

import SwiftUI

struct ContentView: View {
  
    @State  var showSheet: Bool = false
    @State private var selectedTab = 1
    @State private var showMainView = false
    
    @EnvironmentObject var globalViewModel: GlobalViewModel
    
//    init() {
//        UITabBar.appearance().scrollEdgeAppearance = .init()
//    }
  
  var body: some View {
      NavigationView() {
          TabView(selection: $selectedTab) {
              MapTabView(showSearchView: $globalViewModel.showSearchView, showSheet : $showSheet)
                  .tabItem {
                      Image(systemName: "map")
                      Text("지도")
                  }.tag(1)
                  .onAppear() {
                      showSheet = true
                  }
                  .fullScreenCover(isPresented: $globalViewModel.showSearchView, onDismiss: {
                      if selectedTab == 1 {
                          showSheet = true
                      }
                  }) {
                      SearchMainView(showLocationSearchView: $globalViewModel.showSearchView)
                  }
              
              BuildingTabView()
                  .tabItem {
                      Image(systemName: "building.2")
                      Text("캠퍼스 맵")
                  }.tag(2)
                  .onAppear() {
                      showSheet = false
                  }
              
              EventTabView()
                  .tabItem {
                      Image(systemName: "calendar")
                      Text("교내 행사")
                  }.tag(3)
                  .onAppear() {
                      showSheet = false
                  }
              
              ProfileTabView()
                  .tabItem {
                      Image(systemName: "person")
                      Text("마이 페이지")
                  }.tag(4)
                  .onAppear() {
                      showSheet = false
                  }
                  .navigationBarBackButtonHidden(true)
              
        }
        .ignoresSafeArea()
        .accentColor(.gachonBlue)
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
        } // end of .sheet
          
      } // end of NavigationStack
      .toolbar(.visible, for: .tabBar)
      
  } // end of body
} // end of View struct

#Preview {
  ContentView()
        .environmentObject(GlobalViewModel())
}

