//
//  test2.swift
//  GachMap
//
//  Created by 이수현 on 5/15/24.
//

import SwiftUI

struct test2: View {
    @EnvironmentObject var nav : NavigationController
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        
            Button(action: {
                self.nav.goPathView = true
                print(nav.goInfo, nav.goPathView, nav.guestInfoEnd)
            }, label: {
                Text("go 3")
            })
            
            NavigationLink("", isActive: self.$nav.goPathView){
                test3()
            }
            .onAppear(){
                self.nav.goPathView = false
            }
//            .onReceive(self.nav.$goPathView, perform: { (out) in
//              if out ==  false {
//                self.presentationMode.wrappedValue.dismiss()
//              }
//            })
        
        
    }
}

#Preview {
    test2()
}
