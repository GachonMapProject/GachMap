//
//  NavigationInfoTestView.swift
//  GachMap
//
//  Created by 이수현 on 4/22/24.
//

import SwiftUI

struct NavigationInfoTestView: View {
    let path = Path().homeToAI
    @ObservedObject var coreLocation = CoreLocationEx()
    let checkRotation = CheckRotation()
    
    @State var rotationList: [Rotation]? = nil
    
    var body: some View {
        if rotationList == nil && coreLocation.location != nil {
            ProgressView()
                .onAppear {
                    self.rotationList = checkRotation.checkRotation(currentLocation: coreLocation.location!, path: path)
                }
        } else {
            if let rotationList = rotationList {
                ScrollView(.horizontal){
                    HStack {
                        ForEach(rotationList) { rotation in
                            NavigationInfoView(distance: Int(rotation.distance), rotation: rotation.rotation)
                        }
                    }
                    .padding()
                }
                

                AppleMap(coreLocation: coreLocation, path: path)
            }
        }
        
        
    }
}

#Preview {
    NavigationInfoTestView()
}
