////
////  test2.swift
////  GachMap
////
////  Created by 이수현 on 5/15/24.
////
//
//import SwiftUI
//
//struct test2: View {
//    @EnvironmentObject var nav : NavigationController
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    var body: some View {
//        
//            Button(action: {
//                self.nav.goPathView = true
//                print(nav.goInfo, nav.goPathView, nav.guestInfoEnd)
//            }, label: {
//                Text("go 3")
//            })
//            
//            NavigationLink("", isActive: self.$nav.goPathView){
//                test3()
//            }
//            .onAppear(){
//                self.nav.goPathView = false
//            }
////            .onReceive(self.nav.$goPathView, perform: { (out) in
////              if out ==  false {
////                self.presentationMode.wrappedValue.dismiss()
////              }
////            })
//        
//        
//    }
//}
//
//#Preview {
//    test2()
//}


import SwiftUI

struct ContentView1: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: View1()) {
                    Text("Go to View 1")
                }
            }
            .navigationTitle("Root View")
        }
    }
}

struct View1: View {
    var body: some View {
        VStack {
            NavigationLink(destination: View2()) {
                Text("Go to View 2")
            }
        }
        .navigationTitle("View 1")
    }
}

struct View2: View {
    var body: some View {
        VStack {
            NavigationLink(destination: View3()) {
                Text("Go to View 3")
            }
        }
        .navigationTitle("View 2")
    }
}

struct View3: View {
    var body: some View {
        VStack {
            NavigationLink(destination: View4()) {
                Text("Go to View 4")
            }
        }
        .navigationTitle("View 3")
    }
}

struct View4: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Button(action: {
                // Dismiss to root view and remove intermediate views
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Go to Root View")
            }
        }
        .navigationTitle("View 4")
    }
}

