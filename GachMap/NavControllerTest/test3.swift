//
//  test3.swift
//  GachMap
//
//  Created by 이수현 on 5/15/24.
//

import SwiftUI

struct test3: View {
    @EnvironmentObject var nav : NavigationController
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        
            Button(action: {
                nav.guestInfoEnd = true
                print(nav.goInfo, nav.goPathView, nav.guestInfoEnd)
            }, label: {
                Text("go 4")
            })
            
            NavigationLink("", isActive: self.$nav.guestInfoEnd){
                test4()
            }
            .onAppear(){
                self.nav.guestInfoEnd = false
            }
        
//            .onReceive(self.nav.$guestInfoEnd, perform: { (out) in
//              if out ==  false {
//                self.presentationMode.wrappedValue.dismiss()
//              }
//            })
        
    }
}

#Preview {
    test3()
}
