//
//  StartView.swift
//  GachonMap
//
//  Created by 이수현 on 4/12/24.
//

import SwiftUI

struct StartView: View {
    @State private var isAROn = false
    var body: some View {
        
        if !isAROn {
            Button(action: {
                isAROn = true
            }){
                Text("AR 길 안내")
            }
        }
        else{
            ARMainView(isAROn: $isAROn, departures: 0, arrivals: 0)
        }
        
    }
}

#Preview {
    StartView()
}
