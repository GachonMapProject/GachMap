//
//  test1.swift
//  GachMap
//
//  Created by 이수현 on 5/15/24.
//

import SwiftUI

struct test1: View {
    @EnvironmentObject var nav : NavigationController
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView{
            VStack{
                Button(action: {
                    self.nav.goInfo = true
                    print(nav.goInfo, nav.goPathView, nav.guestInfoEnd)
                }, label: {
                    Text("go 2")
                })
                
                NavigationLink("", isActive: self.$nav.goInfo){
//                    test2()
                }
            }
            .onAppear(){
                self.nav.goInfo = false
            }
//            .onReceive(self.nav.$goInfo, perform: { (out) in
//              if out ==  false {
//                self.presentationMode.wrappedValue.dismiss()
//              }
//            })
         
        }
    }
}

#Preview {
    test1()
}
