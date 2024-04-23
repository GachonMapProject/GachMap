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
                ZStack(alignment : .bottom){
                    AppleMap(coreLocation: coreLocation, path: path)
                    ScrollView(.horizontal){
                        ZStack(){
                            LazyHStack{
                                ForEach(rotationList) { rotation in
                                    NavigationInfoView(distance: Int(rotation.distance), rotation: rotation.rotation)
                                        .scrollTransition(.animated, axis: .horizontal) { content, phase in
                                            content
                                                .opacity(phase.isIdentity ? 1.0 : 0.8)
                                                .scaleEffect(phase.isIdentity ? 1.0 : 0.8)
                                        }
                                }
                            } // end of LazyStack
                            .padding(EdgeInsets(top: 0, leading: 30, bottom: 30, trailing: 30))
                            .scrollTargetLayout()
                            
                        } // end of ZStack
                        
                    } // end of ScrollView
                    .scrollTargetBehavior(.viewAligned)
                    .frame(height: UIScreen.main.bounds.width * 0.3)
                }


                


            }
        }
        
        
    }
}

#Preview {
    NavigationInfoTestView()
}
