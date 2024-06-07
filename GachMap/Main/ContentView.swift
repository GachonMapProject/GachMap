//
//  ContentView.swift
//  GachonMap
//
//  Created by 이수현 on 4/9/24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var globalViewModel: GlobalViewModel
    
//    init() {
//        UITabBar.appearance().scrollEdgeAppearance = .init()
//    }
  
  var body: some View {
      NavigationView() {
          TabView(selection: $globalViewModel.selectedTab) {
              MapTabView(showSearchView: $globalViewModel.showSearchView, showSheet : $globalViewModel.showSheet)
                  .tabItem {
                      Image(systemName: "map")
                      Text("지도")
                  }.tag(1)
                  .onAppear() {
                      globalViewModel.showSheet = true
                  }
                  .fullScreenCover(isPresented: $globalViewModel.showSearchView, onDismiss: {
                      if globalViewModel.selectedTab == 1 {
                          globalViewModel.showSheet = true
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
                      globalViewModel.showSheet = false
                  }
              
              EventTabView()
                  .tabItem {
                      Image(systemName: "calendar")
                      Text("교내 행사")
                  }.tag(3)
                  .onAppear() {
                      globalViewModel.showSheet = false
                  }
              
              ProfileTabView()
                  .tabItem {
                      Image(systemName: "person")
                      Text("마이 페이지")
                  }.tag(4)
                  .onAppear() {
                      globalViewModel.showSheet = false
                  }
                  .navigationBarBackButtonHidden(true)
              
        }
        .ignoresSafeArea()
        .accentColor(.gachonBlue)
        .sheet(isPresented: $globalViewModel.showSheet) {
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

