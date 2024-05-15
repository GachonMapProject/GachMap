//
//  test4.swift
//  GachMap
//
//  Created by 이수현 on 5/15/24.
//

import SwiftUI

struct test4: View {
    @EnvironmentObject var nav : NavigationController
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
//        NavigationView{
//            NavigationLink("test1", isActive: self.$nav.goInfo){
//                test2()
//            }
//        }
        
        Button(action: {
            nav.guestInfoEnd = false
            nav.goPathView = false
            nav.goInfo = false
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                self.presentationMode.wrappedValue.dismiss()
//            }
            
            print(nav.goInfo, nav.goPathView, nav.guestInfoEnd)
        }, label: {
            Text("return root")
        })
//        .onAppear(){
//            self.nav.guestInfoEnd = false
//        }

    }
}

#Preview {
    test4()
}
